//
//  Part.swift
//  Share
//

import ShareLib
import Math

struct Part {
	var primeBits: Int
	var index: Int
	var count: Int
	var values: [UInt8]
	
	init(primeBits: Int, index: Int, count: Int, values: [UInt8]) {
		self.primeBits = primeBits
		self.index = index
		self.count = count
		self.values = values
	}
	
	static func split(bytes: [UInt8],
					  primeBits: Int,
					  count: Int, needed: Int) -> [Part] {
		let bytes: [UInt64] = bytes.asBigEndian(sourceBits: 8,
												resultBits: primeBits - 1)
		let prime = self.prime(of: primeBits)
		let shares = bytes.map {
			Share.split(value: $0, prime: prime,
						count: UInt64(count), needed: UInt64(needed))
		}
		return (0..<count).map { index in
			let data: [UInt8] = shares.flatMap { shareList in
				shareList[index].value
			}.asBigEndian(sourceBits: primeBits, resultBits: 8)
			return Part(primeBits: primeBits,
						index: index+1, count: count,
						values: data)
		}
	}
	
	static func join(shares: [Part]) -> [UInt8]? {
		guard shares.count > 0 else { return nil }
		guard shares.map({$0.count}).allEqual() else { return nil }
		guard shares.map({$0.primeBits}).allEqual() else { return nil }
		guard shares.map({$0.values.count}).allEqual() else { return nil }
		
		let primeBits = shares[0].primeBits
		let prime = self.prime(of: primeBits)
		
		let data: [(Int, [UInt64])] = shares.map { ($0.index, $0.values.asBigEndian(sourceBits: 8, resultBits: primeBits)) }
		let newShares = (0..<data[0].1.count).map { index in
			data
				.map { ($0.0, $0.1[index]) }
				.map { Share(index: UInt64($0.0), value: $0.1) }
		}
		let secret = newShares.map { Share.join(shares: $0, prime: prime) }
		
		let realSecret = secret.flatMap { $0 }
		guard realSecret.count == secret.count else { return nil }
		return realSecret.asBigEndian(sourceBits: primeBits - 1, resultBits: 8)
	}
	
	private static func prime(of bits: Int) -> UInt64 {
		switch bits {
			case  7: return 127
			case 13: return 8191
			case 17: return 131071
			case 19: return 524287
			case 31: return 2147483647
			case 61: return 2305843009213693951
			default: fatalError("THESE BITS ARENT PRIME M8")
		}
	}
}
