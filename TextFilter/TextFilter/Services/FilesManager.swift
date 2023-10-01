//
//  FilesManager.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import Foundation

/// Пречисление для ошибок файлового менеджера
enum FilesManagerError: Error {
	case fileAlreadyExists
	case fileNotExist
	case invalidDirectory
	case writtingFailed(reason: String)
	case readingFailed(reason: String)
}

/// Протокол класса для работы с файлами в памяти устройства.
protocol IFilesManager {
	
	/// Получить путь к каталогу расположения программы.
	/// - Returns: Путь к каталогу.
	func getPath() -> String
	
	/// Сохранить файл в память устройства.
	/// - Parameters:
	///   - fileName: Наименование файла.
	///   - dot: Расширение файла.
	///   - data: Данные для записи в файл.
	///   - isRewrite: Перезаписать файл.
	func save(fileName: String, dot: String, data: Data, isRewrite: Bool) throws
	
	/// Прочитать файл в каталоге программы.
	/// - Parameters:
	///   - fileName: Наименование файла.
	///   - dot: Расширение файла.
	/// - Returns: Данные файла.
	func read(fileName: String, dot: String) throws -> Data
}

/// Класса для работы с файлами в памяти устройства.
final class FilesManager: IFilesManager {
	
	// MARK: - Private properties
	
	private let fileManager: FileManager
	
	// MARK: - Initialization
	
	init(fileManager: FileManager = .default) {
		self.fileManager = fileManager
	}
	
	// MARK: - Publick Methods
	
	func save(fileName: String, dot: String, data: Data, isRewrite: Bool) throws {
		guard let url = makeURL(forFileName: fileName, dot: dot) else {
			throw FilesManagerError.invalidDirectory
		}
		
		if fileManager.fileExists(atPath: url.path) {
			if isRewrite {
				try fileManager.removeItem(atPath: url.path)
			} else {
				throw FilesManagerError.fileAlreadyExists
			}
		}
		
		do {
			try data.write(to: url)
		} catch {
			throw FilesManagerError.writtingFailed(reason: error.localizedDescription)
		}
	}
	
	func read(fileName: String, dot: String) throws -> Data {
		guard let url = makeURL(forFileName: fileName, dot: dot) else {
			throw FilesManagerError.invalidDirectory
		}
		
		guard fileManager.fileExists(atPath: url.path) else {
			throw FilesManagerError.fileNotExist
		}
		
		do {
			return try Data(contentsOf: url)
		} catch {
			throw FilesManagerError.readingFailed(reason: error.localizedDescription)
		}
	}
	
	func getPath() -> String {
		NSSearchPathForDirectoriesInDomains(
			FileManager.SearchPathDirectory.libraryDirectory,
			FileManager.SearchPathDomainMask.userDomainMask,
			true
		).first ?? "/"
	}
	
	// MARK: - Private Methods
	
	private func makeURL(forFileName fileName: String, dot: String) -> URL? {
		guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		
		return url.appendingPathComponent(fileName).appendingPathExtension(dot)
	}
}

// MARK: - LocalizedError

extension FilesManagerError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .fileAlreadyExists:
			return L10n.FilesManagerError.fileAlreadyExists
		case .fileNotExist:
			return L10n.FilesManagerError.fileNotExist
		case .invalidDirectory:
			return L10n.FilesManagerError.invalidDirectory
		case .writtingFailed(let reason):
			return L10n.FilesManagerError.writtingFailed + reason
		case .readingFailed(let reason):
			return L10n.FilesManagerError.readingFailed + reason
		}
	}
}
