//
//  StringListViewControllerTests.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import XCTest
@testable import TextFilter

final class StringListViewControllerTests: XCTestCase {
	
	// MARK: - Private Properties
	
	private let networkManager = NetworkManagerSpy()
	private let filesManager = FilesManagerSpy()
	private let filterService = FilterServiceSpy()
	private let tableViewSpy = TableViewSpy()
	private let activityIndicatorSpy = ActivityIndicatorViewSpy()
	
	// MARK: - Publick Methods
	
	func test_reloadData_shouldBeNetworkManagerFetchDataCalled() {
		let exp = expectation(description: "Проверяем пока данные будут загружены")
		let sut = makeSut()
		
		sut.reloadData(with: "", and: "")
		networkManager.fetchData(from: "") { _ in
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 2.0)
		
		XCTAssertTrue(networkManager.isCalledFetch, "NetworkManager.fetchData не был вызван")
	}
	
	func test_reloadData_shouldBeFilesManagerSaveCalled() {
		let exp = expectation(description: "Проверяем пока данные будут загружены")
		let sut = makeSut()
		
		sut.reloadData(with: "", and: "")
		networkManager.fetchData(from: "") { _ in
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 2.0)
		
		XCTAssertTrue(filesManager.isCalled, "FilesManager.save не был вызван")
	}
	
	func test_reloadData_shouldBeFilterServiceFilteredFromCalled() {
		let exp = expectation(description: "Проверяем пока данные будут загружены")
		let sut = makeSut()
		
		sut.reloadData(with: "", and: "")
		networkManager.fetchData(from: "") { _ in
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 2.0)
		
		XCTAssertTrue(filterService.isCalled, "FilterService.filterFrom не был вызван")
	}
	
	func test_reloadData_tableViewShouldBeContainTwoRows() {
		let exp = expectation(description: "Проверяем пока данные будут загружены")
		let sut = makeSut()

		sut.reloadData(with: "", and: "")
		networkManager.fetchData(from: "") { _ in
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 2.0)
		
		let tableRowsCount = sut.tableView.numberOfRows(inSection: 0)
		XCTAssertEqual(tableRowsCount, 2, "Количество строк в таблице не равно двум")
	}
	
	func test_reloadData_activityIndicatorMustBeHiddenAndTableViewReloaded() {
		let exp = expectation(description: "Проверяем пока данные будут загружены")
		let sut = makeSut()
		
		sut.reloadData(with: "", and: "")
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
			exp.fulfill()
		}

		waitForExpectations(timeout: 4.0)
		
		XCTAssertTrue(self.activityIndicatorSpy.isHidden, "Activity Indicator не был скрыт")
		XCTAssertTrue(self.tableViewSpy.isCalledReloadData, "TableView не был обновлен")
	}
}

// MARK: - Private

private extension StringListViewControllerTests {
	func makeSut() -> StringListViewController {
		let viewController = StringListViewController(
			networkManager: networkManager,
			filesManager: filesManager,
			filterService: filterService
		)
		
		viewController.activityIndicator = activityIndicatorSpy
		viewController.tableView = tableViewSpy
		viewController.tableView.dataSource = viewController
		
		return viewController
	}
}
