//
//  FiniteFields.swift
//  Share
//

import Math

struct FF_7: FiniteFieldInteger {
	static var Order = UInt8(127)
	var value: Element = 0
	var bitWidth = 7
}

struct FF_13: FiniteFieldInteger {
	static var Order = UInt16(8191)
	var value: Element = 0
	var bitWidth = 13
}

struct FF_17: FiniteFieldInteger {
	static var Order = UInt32(131071)
	var value: Element = 0
	var bitWidth = 17
}

struct FF_19: FiniteFieldInteger {
	static var Order = UInt32(524287)
	var value: Element = 0
	var bitWidth = 19
}

struct FF_31: FiniteFieldInteger {
	static var Order = UInt32(2147483647)
	var value: Element = 0
	var bitWidth = 31
}

struct FF_61: FiniteFieldInteger {
	static var Order = UInt64(2305843009213693951)
	var value: Element = 0
	var bitWidth = 61
}

struct FF_89: FiniteFieldInteger {
	static var Order = BigUInt("618970019642690137449562111")!
	var value: Element = 0
	var bitWidth = 89
}
