//
//  ShareTests.swift
//  Share
//

import XCTest
import ShareLib

class ShareTests: XCTestCase {
	func testShare() {
		let prime: Int8 = 127
		let secret: Int8 = 34
		let shares = Share.split(value: secret, prime: prime, count: 6, needed: 3)
		let newShares = [2,1,5].map { shares[$0] }
		let newSecret = Share.join(shares: newShares, prime: prime)
		XCTAssertEqual(newSecret, secret)
		
		let prime2: UInt8 = 251
		let secret2: UInt8 = 200
		let shares2 = Share.split(value: secret2, prime: prime2, count: 30, needed: 3)
		let newShares2 = [2,3,5].map { shares2[$0] }
		let newSecret2 = Share.join(shares: newShares2, prime: prime2)
		XCTAssertEqual(newSecret2, secret2)
	}
	
	func test2() {
		let prime: UInt64 = 2305843009213693951
		let secret: UInt64 = 35465345454353
		let shares = Share.split(value: secret, prime: prime, count: 6, needed: 3)
		let newShares = [2,1,3].map { shares[$0] }
		let newSecret = Share.join(shares: newShares, prime: prime)
		XCTAssertEqual(newSecret, secret)
	}
	
	static var allTests = [
		("testShare", testShare)
	]
}
