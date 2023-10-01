//
//  NetworkManagerSpy.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import Foundation
@testable import TextFilter

class NetworkManagerSpy: INetworkManager {
	
	// MARK: - Internal Properties

	private(set) var isCalledFetch = false
	private(set) var isCalledGenerateURL = false

	// MARK: - Publick Methods
	
	func fetchData(from stringUrl: String, completion: @escaping (Result<String, TextFilter.NetworkError>) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
			self.isCalledFetch = true
			completion(.success("FooBarBuz\nABCxyz"))
		}
	}
	
	func generateURL(from url: String) throws -> URL {
		isCalledGenerateURL = true
		return URL(string: "https://google.com")!
	}
}
