//
//  ShareTests.swift
//  Share
//

import XCTest
import Math
import ShareLib

struct F_7: FiniteFieldInteger {
	static var Order = UInt8(7)
	var value: Element = 0
}

struct F_251: FiniteFieldInteger {
	static var Order = UInt8(251)
	var value: Element = 0
}

struct F_2305843009213693951: FiniteFieldInteger {
	static var Order = BigUInt("2305843009213693951")!
	var value: Element = 0
}

struct F_big: FiniteFieldInteger {
	static var Order = BigUInt("618970019642690137449562111")!
	var value: Element = 0
}

final class ShareTests: XCTestCase {
	func testShare8() {
		let secret: F_251 = 200
		let shares = Share.split(value: secret, count: 30, needed: 12)
		let newShares = shares.shuffled().prefix(12)
		let newSecret = Share.join(shares: newShares)
		XCTAssertEqual(newSecret, secret)
	}
	
	func testMissingShares() {
		let secret: F_251 = 200
		let shares = Share.split(value: secret, count: 30, needed: 12)
		let newShares = shares.shuffled().prefix(11)
		let newSecret = Share.join(shares: newShares)
		XCTAssertNotEqual(newSecret, secret)
	}
	
	func testShare64() {
		let secret: F_2305843009213693951 = 35465345454353
		let shares = Share.split(value: secret, count: 6, needed: 3)
		let newShares = shares.shuffled().prefix(3)
		let newSecret = Share.join(shares: newShares)
		XCTAssertEqual(newSecret, secret)
	}
	
	func testShareBig() {
		let secret = F_big("6189719642690137449562111")!
		let shares = Share.split(value: secret, count: 6, needed: 3)
		let newShares = shares.shuffled().prefix(3)
		let newSecret = Share.join(shares: newShares)
		XCTAssertEqual(newSecret, secret)
	}
}

extension ShareTests: TestCase {
	static var allTests = [
		("testShare8", testShare8),
		("testMissingShares", testMissingShares),
		("testShare64", testShare64),
		("testShareBig", testShareBig),
	]
}
