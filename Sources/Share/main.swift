//
//  main.swift
//  Share
//

import CommandLine
import Foundation

func main() throws {
	let parser = ArgumentParser()
	let unparsed = try parser.parse()
	
	guard let first = unparsed.first?.lowercased() else {
		print("USAGE: Share <split | merge>")
		return
	}
	
	switch first {
		case "split": try split()
		case "merge": try merge()
		default:
			print("USAGE: Share <split | merge>")
			return
	}
}

func split() throws {
	var count: Int?
	var needed: Int?
	var input: String?
	var output: String?
	var security: Int?
	var help = false
	
	let parser = ArgumentParser(strict: true)
	parser.intOption(short: "c",
					 long: "count",
					 description: "Number of parts to create") { count = $0 }
	parser.intOption(short: "n",
					 long: "needed",
					 description: "Number of parts needed") { needed = $0 }
	parser.intOption(short: "s",
					 long: "security",
					 description: "The security level (0,1,2,3,4,9)") {
						switch $0 {
							case 0: security = 7
							case 1: security = 13
							case 2: security = 17
							case 3: security = 19
							case 4: security = 31
							case 9: security = 61
							default: print("Invalid security: \($0)")
						}
	}
	parser.stringOption(short: "i",
						long: "input",
						description: "Input file") { input = $0 }
	parser.stringOption(short: "o",
						long: "output",
						description: "Output file pattern (A%B.txt -> A1B.txt, A2B.txt)") { output = $0 }
	parser.boolOption(short: "h",
					  long: "help",
					  description: "Print help") { help = $0 }
	_ = try parser.parse()
	
	if help {
		print("USAGE: Share split <options>\n")
		print(parser.usage())
		return
	}
	
	guard let realCount = count else {
		print("Missing count\n")
		print(parser.usage())
		return
	}
	guard let realNeeded = needed else {
		print("Missing needed\n")
		print(parser.usage())
		return
	}
	guard let realInput = input else {
		print("Missing input\n")
		print(parser.usage())
		return
	}
	guard let realOutput = output else {
		print("Missing output\n")
		print(parser.usage())
		return
	}
	guard realOutput.contains("%") else {
		print("Invalid output format\n")
		print(realOutput)
		return
	}
	guard let realSecurity = security else {
		print("Missing security\n")
		print(parser.usage())
		return
	}
	try split(realCount, realNeeded, realSecurity, realInput, realOutput)
}

func merge() throws {
	var output: String?
	
	let parser = ArgumentParser(strict: true)
	parser.stringOption(short: "o",
						long: "output",
						description: "Output file") { output = $0 }
	let files = try parser.parse().dropFirst()
	
	if files.isEmpty {
		print("Usage: Share merge <options> <input...>\n")
		print(parser.usage())
		return
	}
	
	try merge(Array(files), output)
}

func split(_ count: Int, _ needed: Int,  _ security: Int, _ input: String, _ output: String) throws {
	let inputData = try Data(contentsOf: URL(fileURLWithPath: input))
	let inputBytes = [UInt8](inputData)
	
	let parts = Part.split(bytes: inputBytes, primeBits: security, count: count, needed: needed)
	try parts.enumerated().forEach { (index, part) in
		let output = output.replacingOccurrences(of: "%", with: "\(index+1)")
		let fileContents = """
		- Index -
		\(index+1)
		- Prime Bits -
		\(security)
		- Needed -
		\(needed)
		- Message -
		
		"""
		guard var data = fileContents.data(using: .utf8) else { throw ShareError.Error("Cannot encode") }
		let byteData = Data(part.values)
		data.append(byteData.base64EncodedData())
		try data.write(to: URL(fileURLWithPath: output), options: .atomic)
	}
}

func merge(_ input: [String], _ output: String?) throws {
	let testIn = try input.map {
		String(data: try Data(contentsOf: URL(fileURLWithPath: $0)), encoding: .utf8)
	}
	let realInput = testIn.flatMap { $0 }
	guard testIn.count == realInput.count else { throw ShareError.Error("Could not read a file") }
	
	let parts = try realInput
		.map { $0.split(separator: "\n").map(String.init) }
		.map { (lines: [String]) -> Part in
			var index: Int?
			var security: Int?
			var needed: Int?
			var message: String?
			var gen = lines.generator()
			while let line = gen.next() {
				switch line {
					case "- Index -":
						guard let nextLine = gen.next() else {
							throw ShareError.Error("Missing index")
						}
						index = Int(nextLine)
					case "- Prime Bits -":
						guard let nextLine = gen.next() else {
							throw ShareError.Error("Missing prime bits")
						}
						security = Int(nextLine)
					case "- Needed -":
						guard let nextLine = gen.next() else {
							throw ShareError.Error("Missing needed")
						}
						needed = Int(nextLine)
					case "- Message -":
						guard let nextLine = gen.next() else {
							throw ShareError.Error("Missing message")
						}
						message = String(nextLine)
					default: throw ShareError.Error("Invalid line: \(line)")
				}
			}
			guard let realIndex = index,
				let primeBits = security,
				let realNeeded = needed,
				let realMessage = message else {
					throw ShareError.Error("Missing something")
			}
			guard let data = Data(base64Encoded: realMessage) else { throw ShareError.Error("Bad data") }
			let bytes = [UInt8](data)
			return Part(primeBits: primeBits,
						index: realIndex,
						count: realNeeded,
						values: bytes)
		}
	
	guard let secretBytes = Part.join(shares: parts) else {
		throw ShareError.Error("Cannot join")
	}
	let data = Data(secretBytes)
	
	if let output = output {
		try data.write(to: URL(fileURLWithPath: output), options: .atomic)
	} else {
		print(String(data: data, encoding: .utf8) ?? "Cannot do the thing")
	}
}

do {
	try main()
} catch let e as ParseError {
	print(e.description)
} catch let e as ShareError {
	print(e.localizedDescription)
} catch let e {
	print(e.localizedDescription)
}
