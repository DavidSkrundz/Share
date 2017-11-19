//
//  LinuxMain.swift
//  Share
//

import XCTest
@testable import ShareLibTests

XCTMain([
	testCase(BitConversionTests.allTests),
	testCase(ModTests.allTests),
	testCase(ShareTests.allTests),
])
