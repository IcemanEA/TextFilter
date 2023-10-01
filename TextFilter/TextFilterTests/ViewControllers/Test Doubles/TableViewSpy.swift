//
//  TableViewSpy.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import XCTest

final class TableViewSpy: UITableView {
	
	// MARK: - Internal Properties
	
	private(set) var isCalledReloadData = false
	
	// MARK: - Override Methods
	
	override func reloadData() {
		super.reloadData()
		isCalledReloadData = true
	}
}
