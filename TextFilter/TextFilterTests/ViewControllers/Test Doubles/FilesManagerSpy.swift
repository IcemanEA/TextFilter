//
//  FilesManagerSpy.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import Foundation
@testable import TextFilter

class FilesManagerSpy: IFilesManager {

	// MARK: - Internal Properties

	private(set) var isCalled = false
	private(set) var savedData = Data()

	// MARK: - Publick Methods
	
	func getPath() -> String {
		isCalled = true
		return ""
	}
	
	func save(fileName: String, dot: String, data: Data, isRewrite: Bool) throws {
		isCalled = true
		savedData = data
	}
	
	func read(fileName: String, dot: String) throws -> Data {
		isCalled = true
		return savedData
	}
}
