//
//  BitConversionTests.swift
//  ShareLibTests
//

import XCTest
import ShareLib

class BitConversionTests: XCTestCase {
	func test8() {
		let array: [UInt8] = [13, 0, 34]
		let solution = array.map { UInt64($0) }
		XCTAssertEqual(array.toNbit(8), solution)
		XCTAssertEqual(solution.fromNbit(8), array)
	}
	
	func test16() {
		let array: [UInt8] = [13, 54, 34]
		let solution: [UInt64] = [3382, 8704]
		let solution2: [UInt8] = [13, 54, 34, 0]
		XCTAssertEqual(array.toNbit(16), solution)
		XCTAssertEqual(solution.fromNbit(16), solution2)
	}
	
	func test1() {
		let array: [UInt8] = [13, 54, 34]
		let solution: [UInt64] = [0,0,0,0,1,1,0,1, 0,0,1,1,0,1,1,0, 0,0,1,0,0,0,1,0]
		XCTAssertEqual(array.toNbit(1), solution)
		XCTAssertEqual(solution.fromNbit(1), array)
	}
	
	func test17() {
		let array: [UInt8] = [1,1,1,1]
		let solution: [UInt64] = [514, 1028]
		let solution2: [UInt8] = [1,1,1,1,0]
		XCTAssertEqual(array.toNbit(17), solution)
		XCTAssertEqual(solution.fromNbit(17), solution2)
	}
	
	static var allTests = [
		("test8", test8),
		("test16", test16),
		("test1", test1),
		("test17", test17)
	]
}
