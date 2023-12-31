//
//  UIColorHexTests.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import XCTest
@testable import TextFilter

final class UIColorHexTests: XCTestCase {
	
	func test_init_withValidParameters_shouldBeInitFailure() {
		let red: UInt8 = 0x26
		let green: UInt8 = 0xea
		let blue: UInt8 = 0x58
		let alpha: UInt8 = 0xff
		let sut = UIColor(red: red, green: green, blue: blue, alpha: alpha)
		
		let expectedColor = UIColor(red: 0x26 / 255.0, green: 0xea / 255.0, blue: 0x58 / 255.0, alpha: 1)
		
		XCTAssertEqual(sut, expectedColor, "Ошибка создания цвета")
	}
	
	func test_init_withWrongInt_shouldBeInitFailure() {
		let color = 0x987654321577
		let sut = UIColor(hex: color)

		let expectedColor = UIColor(red: 0x98 / 255.0, green: 0x76 / 255.0, blue: 0x54 / 255.0, alpha: 0x32 / 255.0)
		
		XCTAssertNotEqual(sut, expectedColor, "Ошибка создания цвета")
	}
	
	func test_init_withWrongInt_shouldBeInitSuccess() {
		let color = 0x987654321577
		let sut = UIColor(hex: color)

		let expectedColor = UIColor(red: 0x54 / 255.0, green: 0x32 / 255.0, blue: 0x15 / 255.0, alpha: 0x77 / 255.0)
		
		XCTAssertEqual(sut, expectedColor, "Ошибка создания цвета")
	}
	
	func test_init_withValidHexString_shouldBeInitSuccess() {
		let color = "#00ff00"
		let sut = UIColor(hex: color)

		let expectedColor = UIColor(red: 0 / 255.0, green: 255 / 255.0, blue: 0 / 255.0, alpha: 1)
		
		XCTAssertEqual(sut, expectedColor, "Ошибка создания цвета")
	}
	
	func test_init_withValidHexString2_shouldBeInitSuccess() {
		let color = "26ea58"
		let sut = UIColor(hex: color)
		
		let expectedColor = UIColor(red: 38 / 255.0, green: 234 / 255.0, blue: 88 / 255.0, alpha: 1)
		
		XCTAssertEqual(sut, expectedColor, "Ошибка создания цвета")
	}
	
	func test_init_withWrongHexString_shouldBeInitFailure() {
		let color = "26ww58"
		let sut = UIColor(hex: color)
		
		let expectedColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
		
		XCTAssertNotNil(sut)
		XCTAssertEqual(sut, expectedColor, "Ошибка создания цвета")
	}
}
