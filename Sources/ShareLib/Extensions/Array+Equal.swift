//
//  Array+Equal.swift
//  ShareLib
//

extension Array where Element: Equatable {
	public func allEqual() -> Bool {
		guard let first = self.first else { return true }
		return self.first { $0 != first } == nil
	}
}
