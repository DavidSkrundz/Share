//
//  FixedWidthInteger+Mod.swift
//  ShareLib
//

extension FixedWidthInteger {
	/// - Precondition: `mod > 0`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func mod(_ mod: Self) -> Self {
		let remainder = self % mod
		return remainder >= 0 ? remainder : remainder + mod
	}
	
	/// - Returns: `(self + other) mod (mod)`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func add(_ other: Self, mod: Self) -> Self {
		let lhs = self.mod(mod)
		let rhs = other.mod(mod)
		
		let (sum, overflow) = lhs.addingReportingOverflow(rhs)
		if overflow == false { return sum.mod(mod) }
		
		let difference = mod - lhs
		return rhs - difference
	}
	
	/// - Returns: `(self - other) mod (mod)`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func sub(_ other: Self, mod: Self) -> Self {
		let lhs = self.mod(mod)
		let rhs = other.mod(mod)
		
		let (sub, overflow) = lhs.subtractingReportingOverflow(rhs)
		if overflow == false { return sub.mod(mod) }
		
		let difference = mod - rhs
		return lhs + difference
	}
	
	/// - Returns: `(self * other) mod (mod)`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func mul(_ other: Self, mod: Self) -> Self {
		let lastBit = Self(1) << (self.bitWidth - 1)
		
		var lhs = self.mod(mod)
		let rhs = other.mod(mod)
		var d: Self = 0
		let mp2 = mod >> 1
		for _ in 0..<self.bitWidth {
			d = (d > mp2) ? (d << 1) &- mod : d << 1
			if lhs & lastBit != 0 {
				d = d.add(rhs, mod: mod)
			}
			lhs <<= 1
		}
		return d.mod(mod)
	}
	
	/// - Returns: `(self ^ other) mod (mod)`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func pow(_ exponent: Self, mod: Self) -> Self {
		var lhs = self
		var rhs = exponent
		var r: Self = 1
		while rhs > 0 {
			if rhs & 1 == 1 {
				r = r.mul(lhs, mod: mod)
			}
			rhs = rhs >> 1
			lhs = lhs.mul(lhs, mod: mod)
		}
		return r.mod(mod)
	}
	
	/// - Returns: (X,Y,Z) such that `X = gcd(self,other)` and
	///            `Y*self + Z*other = X`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func gcdD(_ other: Self) -> (Self, Self, Self) {
		guard other != 0 else { return (self, 1, 0) }
		guard other != -1 else { return (1, 0, -1) }
		let n = self / other
		let c = self % other
		let r = other.gcdD(c)
		if r.0 < 0 {
			return (0&-r.0, 0-r.2, r.2&*n - r.1)
		}
		return (r.0, r.2, r.1 &- r.2&*n)
	}
	
	/// - Precondition: `mod > 1`
	///
	/// - Returns: `R` such that `(self * R) mod (mod) == 1` or `nil`
	@_specialize(where Self == Int8)
	@_specialize(where Self == UInt8)
	@_specialize(where Self == Int16)
	@_specialize(where Self == UInt16)
	@_specialize(where Self == Int32)
	@_specialize(where Self == UInt32)
	@_specialize(where Self == Int64)
	@_specialize(where Self == UInt64)
	internal func inv(_ mod: Self) -> Self? {
		precondition(mod > 1)
		guard self.gcdD(mod).0 == 1 else { return nil }
		if Self.isSigned {
			let k = self % mod
			let r = (k < 0) ? 0-mod.gcdD(0-k).2 : mod.gcdD(k).2
			return r.add(mod, mod: mod)
		} else {
			var lhs = self
			var new: Self = 1
			var old: Self = 0
			var q: Self = mod
			var h: Self = 0
			var pos = false
			while lhs != 0 {
				let r = q % lhs
				q = q / lhs
				h = q * new + old
				old = new
				new = h
				q = lhs
				lhs = r
				pos = !pos
			}
			return pos ? old : (mod - old)
		}
	}
}
