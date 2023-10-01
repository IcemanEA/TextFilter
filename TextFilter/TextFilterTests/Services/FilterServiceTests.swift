//
//  FilterServiceTests.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import XCTest
@testable import TextFilter

final class FilterServiceTests: XCTestCase {
	
	// MARK: - Private Properties
	
	private let stringToFilter = "Foo Bar Buz\nABCxyz"
	
	private let filterOriginal = "ABCxyz"
	private let filterAll = "*ar*"
	private let filterAllFirst = "*yz"
	private let filterAllLast = "Fo*"
	private let filterOneFirst = "?oo*"
	private let filterOneLast = "*xy?"
	
	// MARK: - Publick Methods
	
	func test_filteredFrom_emptyFilter_shouldBeOriginalTextWithTwoStrings() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: "")
		let text = strings.joined(separator: "\n")
		
		XCTAssertEqual(strings.count, 2, "Количество строк в итоговом массиве не равно двум.")
		XCTAssertEqual(stringToFilter, text, "Текст в полученном массиве не соответсвует оригиналу.")
	}
	
	func test_filteredFrom_withFilterWithoutRE_shouldBeLastString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterOriginal)
		let firstString = strings.last ?? ""
		let text = stringToFilter.components(separatedBy: "\n").last ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в последней строке не соответсвует фильру без использования знаков.")
	}
	
	func test_filteredFrom_withFilterAll_shouldBeFirstString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterAll)
		let firstString = strings.first ?? ""
		let text = stringToFilter.components(separatedBy: "\n").first ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в первой строке не соответсвует оригинальной c фильтром *some*.")
	}
	
	func test_filteredFrom_withFilterAllFirst_shouldBeLastString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterAllFirst)
		let firstString = strings.last ?? ""
		let text = stringToFilter.components(separatedBy: "\n").last ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в последней строке не соответсвует оригинальной c фильтром *some.")
	}
	
	func test_filteredFrom_withFilterAllLast_shouldBeFirstString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterAllLast)
		let firstString = strings.first ?? ""
		let text = stringToFilter.components(separatedBy: "\n").first ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в первой строке не соответсвует оригинальной c фильтром some*.")
	}
	
	func test_filteredFrom_withFilterOneFirst_shouldBeFirstString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterOneFirst)
		let firstString = strings.first ?? ""
		let text = stringToFilter.components(separatedBy: "\n").first ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в первой строке не соответсвует оригинальной c фильтром ?some.")
	}
	
	func test_filteredFrom_withFilterOneLast_shouldBeLastString() {
		let sut = makeSut()
		
		let strings = try! sut.filteredFrom(string: stringToFilter, with: filterOneLast)
		let firstString = strings.last ?? ""
		let text = stringToFilter.components(separatedBy: "\n").last ?? ""
		
		XCTAssertEqual(firstString, text, "Текст в последней строке не соответсвует оригинальной c фильтром some?.")
	}
}

// MARK: - Private

private extension FilterServiceTests {
	func makeSut() -> FilterService {
		FilterService()
	}
}
