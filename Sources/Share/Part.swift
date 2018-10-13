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
	
	static func split(bytes: [UInt8], primeBits: Int, count: Int, needed: Int) -> [Part] {
		switch primeBits {
			case  7: return self.split(FF_7 .self, bytes: bytes, count: count, needed: needed)
			case 13: return self.split(FF_13.self, bytes: bytes, count: count, needed: needed)
			case 17: return self.split(FF_17.self, bytes: bytes, count: count, needed: needed)
			case 19: return self.split(FF_19.self, bytes: bytes, count: count, needed: needed)
			case 31: return self.split(FF_31.self, bytes: bytes, count: count, needed: needed)
			case 61: return self.split(FF_61.self, bytes: bytes, count: count, needed: needed)
			case 89: return self.split(FF_89.self, bytes: bytes, count: count, needed: needed)
			default: fatalError("THESE BITS ARENT PRIME M8")
		}
	}
	
	static func join(shares: [Part]) -> [UInt8]? {
		guard shares.count > 0 else { return nil }
		guard shares.map({$0.count}).allEqual() else { return nil }
		guard shares.map({$0.primeBits}).allEqual() else { return nil }
		guard shares.map({$0.values.count}).allEqual() else { return nil }
		
		switch shares[0].primeBits {
			case  7: return self.join(FF_7 .self, shares: shares)
			case 13: return self.join(FF_13.self, shares: shares)
			case 17: return self.join(FF_17.self, shares: shares)
			case 19: return self.join(FF_19.self, shares: shares)
			case 31: return self.join(FF_31.self, shares: shares)
			case 61: return self.join(FF_61.self, shares: shares)
			case 89: return self.join(FF_89.self, shares: shares)
			default: fatalError("THESE BITS ARENT PRIME M8")
		}
	}
	
	private static func split<T: FiniteFieldInteger>(_ type: T.Type, bytes: [UInt8], count: Int, needed: Int) -> [Part] {
		let values: [T] = bytes.asBigEndian()
		let shares = values.map {
			Share.split(value: $0, count: count, needed: needed)
		}
		return (0..<count).map { index in
			let data: [UInt8] = shares.map { $0[index].value }.asBigEndian()
			return Part(primeBits: T().bitWidth, index: index+1, count: count, values: data)
		}
	}
	
	static func join<T: FiniteFieldInteger>(_ type: T.Type, shares: [Part]) -> [UInt8] {
		let data: [(Int, [T])] = shares.map { ($0.index, $0.values.asBigEndian()) }
		let newShares = (0..<data[0].1.count).map { index in
			data.map { ($0.0, $0.1[index]) }
				.map { Share(index: T($0.0), value: $0.1) }
		}
		return newShares.map { Share.join(shares: $0) }.asBigEndian()
	}
}
