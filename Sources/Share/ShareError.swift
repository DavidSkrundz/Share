//
//  ShareError.swift
//  Share
//

enum ShareError: Error {
	case Error(String)
	
	var localizedDescription: String {
		switch self {
			case .Error(let str): return str
		}
	}
}
