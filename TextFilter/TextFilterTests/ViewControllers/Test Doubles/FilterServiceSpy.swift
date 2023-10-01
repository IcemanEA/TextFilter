//
//  FilterServiceSpy.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import Foundation
@testable import TextFilter

class FilterServiceSpy: IFilterService {

	// MARK: - Internal Properties

	private(set) var isCalled = false

	// MARK: - Publick Methods
	
	func filteredFrom(string: String, with filterString: String) -> [String] {
		isCalled = true
		return ["FooBarBuz", "ABCxyz"]
	}
}
