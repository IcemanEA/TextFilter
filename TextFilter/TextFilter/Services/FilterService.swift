//
//  FilterService.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import Foundation

/// Пречисление для ошибок сервиса фильтра строк
enum FilterServiceError: Error {
	case invalidComponentString
	case invalidRegex
}

/// Протокол класса фильтрации строки
protocol IFilterService {
		
	/// Отфильтровать строку и разбить на отдельные строки.
	/// - Parameters:
	///   - string: Строка для фильтрации.
	///   - filterString: Фильтр.
	/// - Returns: Массив отфильтрованных строк.
	func filteredFrom(string: String, with filterString: String) throws -> [String]
}

/// Класс фильтрации строки
final class FilterService: IFilterService {
	
	private let regexOptions: NSRegularExpression.Options
	
	init() {
		regexOptions = [.allowCommentsAndWhitespace, .caseInsensitive, .useUnixLineSeparators]
	}
	
	// MARK: - Publick Methods
	
	func filteredFrom(string: String, with filterString: String) throws -> [String] {
		let strings = string.components(separatedBy: "\n")
		
		return try filteredFrom(array: strings, with: filterString)
	}
	
	// MARK: - Private Methods
	
	private func filteredFrom(array: [String], with filterString: String) throws -> [String] {
		if filterString.isEmpty {
			return array
		}
		
		let pattern = createRegexPattern(filterString)
		
		guard let regex = try? NSRegularExpression(pattern: pattern, options: regexOptions) else {
			throw FilterServiceError.invalidRegex
		}
		
		return array.filter { string in
			let range = NSRange(string.startIndex ..< string.endIndex, in: string)
			
			let result = regex.matches(in: string, range: range)
			
			return !result.isEmpty
		}
	}
	
	private func createRegexPattern(_ filterString: String) -> String {
		var pattern = clearAnyStars(filterString)
		
		pattern = pattern.replacingOccurrences(of: "*", with: ".*")
		pattern = pattern.replacingOccurrences(of: "?", with: ".?")
		pattern = "^\(pattern)$"
		
		return pattern
	}
	
	private func clearAnyStars(_ filterString: String) -> String {
		var tempString = ""
		var prevCharacter = ""
		
		filterString.forEach { char in
			if prevCharacter != "*" || char != "*" {
				tempString.append(char)
			}
			prevCharacter = String(char)
		}
		
		return tempString
	}
}

// MARK: - LocalizedError

extension FilterServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidComponentString:
			return L10n.FilterServiceError.invalidComponentString
		case .invalidRegex:
			return L10n.FilterServiceError.invalidRegex
		}
	}
}

