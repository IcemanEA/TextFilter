//
//  NetworkManager.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import Foundation

/// Перечисление для хранения ошибок сети
enum NetworkError: Error {
	case invalidURL
	case noData
	case noNetwork(reason: String)
}

/// Перечисление адресов  с тестовыми текстами
enum NetworkLink: String {
	case p500 = "https://ledkov.org/texts/test_task_500.txt"
	case p5000 = "https://ledkov.org/texts/test_task_5000.txt"
	case p15000 = "https://ledkov.org/texts/test_task_15000.txt"
	case p30000 = "https://ledkov.org/texts/test_task_30000.txt"
}

/// Протокол для класса работы с сетью
protocol INetworkManager {
	
	/// Загрузить данные из сети.
	/// - Parameter stringUrl: Адрес запроса.
	/// - Parameter completion: Вывод результата в основной поток.
	func fetchData(from stringUrl: String, completion: @escaping (Result<String, NetworkError>) -> Void)
	
	/// Сгенерировать URL из строки адреса. Можно использовать в качестве проверки конвертации без обработки результата.
	/// - Parameter url: Адрес запроса.
	/// - Returns: Готовый URL для использования.
	@discardableResult
	func generateURL(from url: String) throws -> URL
}

/// Класс для работы с сетью
final class NetworkManager: INetworkManager {
	
	// MARK: - Private properties
	
	private let session: URLSession
	
	// MARK: - Initialize
	
	init() {
		let configuration = URLSessionConfiguration.default
		
		configuration.urlCache = nil
		configuration.requestCachePolicy = .reloadIgnoringCacheData
		configuration.timeoutIntervalForRequest = 30
		configuration.timeoutIntervalForResource = 60
		
		session = URLSession(configuration: configuration)
	}
	
	// MARK: - Publick Methods
	
	func fetchData(from stringUrl: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
		let url: URL
		
		do {
			url = try generateURL(from: stringUrl)
		} catch {
			completion(.failure(.invalidURL))
			return
		}
		
		let request = URLRequest(url: url)
		session.dataTask(with: request) { data, _, error in
			if let error {
				completion(.failure(.noNetwork(reason: error.localizedDescription)))
				return
			}
			
			guard let data, let string = String(data: data, encoding: .ascii) else {
				completion(.failure(.noData))
				return
			}
			
			completion(.success(string))
		}
		.resume()
	}
	
	@discardableResult
	func generateURL(from url: String) throws -> URL {
		guard let url = URL(string: url) else {
			throw NetworkError.invalidURL
		}
		
		return url
	}
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return L10n.NetworkError.invalidURL
		case .noData:
			return L10n.NetworkError.noData
		case .noNetwork(let reason):
			return L10n.NetworkError.noNetwork + reason
		}
	}
}
