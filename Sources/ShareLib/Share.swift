//
//  Share.swift
//  ShareLib
//

import LibC
import Math

public struct Share<T: FiniteFieldInteger> {
	public let index: T
	public let value: T
	
	public init(index: T, value: T) {
		self.index = index
		self.value = value
	}
	
	public static func split(value: T, count: Int, needed: Int) -> [Share] {
		if count >= T.Order { fatalError("Cannot produce more shares than the modulus") }
		let coef = (1..<count).map { _ in T.random() }
		var shares = [Share]()
		for x in (1...count) {
			var accumulator = value
			for exp in 1..<needed {
				accumulator += coef[Int(exp-1)] * T(x).exponentiating(by: T(exp))
			}
			let share = Share(index: T(x), value: accumulator)
			shares.append(share)
		}
		return shares
	}
	
	public static func join<S: RandomAccessCollection>(shares: S) -> T where S.Element == Share, S.Index == Int {
		var accum: T = 0
		for formula in 0..<shares.count {
			var numerator = T(1)
			var denominator = T(1)
			for count in 0..<shares.count {
				if formula == count { continue }
				let startposition = shares[formula].index
				let nextposition = shares[count].index
				numerator *= T(0) - nextposition
				denominator *= startposition - nextposition
			}
			accum += shares[formula].value * numerator / denominator
		}
		return accum
	}
}
