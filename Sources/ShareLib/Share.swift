//
//  Share.swift
//  ShareLib
//

import LibC
import Swift

public struct Share<T: FixedWidthInteger> where T.Stride: SignedInteger {
	public let index: T
	public let value: T
	
	public init(index: T, value: T) {
		self.index = index
		self.value = value
	}
	
	public static func split(value: T, prime: T, count: T, needed: T) -> [Share] {
		let coef = (T(1)..<count).map { _ in T.random(max: prime) }
		var shares = [Share]()
		for x in (T(1)...count) {
			var accumulator = value
			for exp in 1..<needed {
				accumulator = accumulator
					.add(coef[Int(truncatingIfNeeded: exp-1)]
						.mul(T(x)
							.pow(T(exp),
								 mod: prime),
							 mod: prime),
						 mod: prime)
			}
			let share = Share(index: T(x),
							  value: accumulator)
			shares.append(share)
		}
		return shares
	}
	
	public static func join(shares: [Share], prime: T) -> T? {
		guard shares.count > 0 else { return  nil }
		
		var accum: T = 0
		for formula in 0..<shares.count {
			var numerator = T(1)
			var denominator = T(1)
			for count in 0..<shares.count {
				if formula == count { continue }
				let startposition = shares[formula].index
				let nextposition = shares[count].index
				numerator = numerator
					.mul(T(0)
						.sub(nextposition,
							 mod: prime),
						 mod: prime)
				denominator = denominator
					.mul(startposition
						.sub(nextposition,
							 mod: prime),
						 mod: prime)
			}
			guard let inv = denominator.inv(prime) else { return nil }
			accum = prime
				.add(accum, mod: prime)
				.add(shares[formula].value
					.mul(numerator, mod: prime)
					.mul(inv,
						 mod: prime),
					 mod: prime)
		}
		return accum
	}
}
