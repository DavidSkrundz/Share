//
//  ModTests.swift
//  Share
//

import XCTest
@testable import ShareLib

class ModTests: XCTestCase {
	func testMod() {
		for a in Int8.min...Int8.max {
			for m in 1...Int8.max {
				if a < 0 {
					XCTAssertEqual(a.mod(m), ((a % m) + m) % m, "\(a) mod \(m)")
				} else {
					XCTAssertEqual(a.mod(m), a % m, "\(a) mod \(m)")
				}
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for m in 1...UInt8.max {
				XCTAssertEqual(a.mod(m), a % m, "\(a) mod \(m)")
			}
		}
	}
	
	func testModAdd() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.add(b, mod: m), Int8((Int(a) + Int(b)).mod(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.add(b, mod: m), UInt8((Int(a) + Int(b)).mod(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
	}
	
	func testModSub() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.sub(b, mod: m), Int8((Int(a) - Int(b)).mod(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.sub(b, mod: m), UInt8((Int(a) - Int(b)).mod(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
	}
	
	func testModMul() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.mul(b, mod: m), Int8((Int(a) * Int(b)).mod(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.mul(b, mod: m), UInt8((Int(a) * Int(b)).mod(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
	}
	
	func testPowMod() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					_ = a.pow(b, mod: m)
				}
			}
		}

		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					_ = a.pow(b, mod: m)
				}
			}
		}
	}
	
	func testGCDD() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				let r = a.gcdD(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				let r = a.gcdD(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
	}
	
	func testInvMod() {
		for a in Int8.min...Int8.max {
			for m in 2...Int8.max {
				if let r = a.inv(m) {
					XCTAssertEqual(a.mul(r, mod: m), 1, "\(a).inv(\(m))")
				}
			}
		}
		
		for a in UInt8.min...UInt8.max {
			for m in 2...UInt8.max {
				if let r = a.inv(m) {
					XCTAssertEqual(a.mul(r, mod: m), 1, "\(a).inv(\(m))")
				}
			}
		}
	}
	
	static var allTests = [
		("testMod", testMod),
		("testModAdd", testModAdd),
		("testModSub", testModSub),
		("testModMul", testModMul),
		("testPowMod", testPowMod),
		("testGCDD", testGCDD),
		("testInvMod", testInvMod)
	]
}
