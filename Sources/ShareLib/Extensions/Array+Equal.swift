//
//  Array+Equal.swift
//  ShareLib
//

extension Array where Element: Equatable {
	public func allEqual() -> Bool {
		guard let first = self.first else { return true }
		return self
			.map { $0 == first }
			.reduce(true) { $0 && $1 }
	}
}
