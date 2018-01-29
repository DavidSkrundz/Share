//
//  Share.swift
//  ShareLib
//

import LibC
import Math

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
					.adding(coef[Int(truncatingIfNeeded: exp-1)]
						.multiplying(T(x)
							.exponentiating(by: T(exp),
								 modulo: prime),
							 modulo: prime),
						 modulo: prime)
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
					.multiplying(T(0)
						.subtracting(nextposition,
							 modulo: prime),
						 modulo: prime)
				denominator = denominator
					.multiplying(startposition
						.subtracting(nextposition,
							 modulo: prime),
						 modulo: prime)
			}
			guard let inv = denominator.inverse(modulo: prime) else { return nil }
			accum = prime
				.adding(accum, modulo: prime)
				.adding(shares[formula].value
					.multiplying(numerator, modulo: prime)
					.multiplying(inv,
						 modulo: prime),
					 modulo: prime)
		}
		return accum
	}
}
