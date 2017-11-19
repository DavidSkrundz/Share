//
//  Array+ByteArray.swift
//  ShareLib
//

extension Array where Element == UInt8 {
	/// Converts a `[UInt8]` to a `[UInt64]` where every element is `n` bits
	///
	/// - Precondition: `n > 0`
	public func toNbit(_ n: Int) -> [UInt64] {
		precondition(n > 0)
		
		let count = (self.count * 8 + n - 1) / n
		var out = [UInt64](repeating: 0, count: count)
		
		var i = 0
		var bits = n
		
		for byte in self {
			for j in 0..<8 {
				out[i] |= ((UInt64(byte) >> (7 - j)) & 1) << (bits - 1)
				bits -= 1
				if bits == 0 {
					bits = n
					i += 1
				}
			}
		}
		
		return out
	}
	
	public func toBitEndianLongs() -> [UInt64] {
		let byteCount = MemoryLayout<UInt64>.size
		var array = [UInt64]()
		
		for i in 0..<(self.count / byteCount) {
			var number = UInt64(0)
			for j in 0..<byteCount {
				number |= UInt64(self[i * byteCount + j]) << UInt64(8 * (byteCount - j - 1))
			}
			array.append(number)
		}
		
		return array
	}

}

extension Array where Element == UInt64 {
	/// Converts a `[UInt64]` to a `[UInt8]` where every element is `n` bits
	///
	/// - Precondition: `n > 0`
	public func fromNbit(_ n: Int) -> [UInt8] {
		precondition(n > 0)
		
		let count = (self.count * n + 8 - 1) / 8
		var out = [UInt8](repeating: 0, count: count)
		
		var i = 0
		var bits = 8
		
		for word in self {
			for j in 0..<n {
				out[i] |= UInt8((word >> (n - 1 - j)) & 1) << (bits - 1)
				bits -= 1
				if bits == 0 {
					bits = 8
					i += 1
				}
			}
		}
		
		return out
	}
}
