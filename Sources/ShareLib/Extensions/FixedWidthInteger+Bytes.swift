//
//  FixedWidthInteger+Bytes.swift
//  ShareLib
//

extension FixedWidthInteger {
	public var bigEndianBytes: [UInt8] {
		var copy = self.bigEndian
		return withUnsafeBytes(of: &copy, Array.init)
	}
}
