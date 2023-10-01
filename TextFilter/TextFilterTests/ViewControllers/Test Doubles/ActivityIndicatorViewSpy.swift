//
//  ActivityIndicatorViewSpy.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import XCTest

final class ActivityIndicatorViewSpy: UIActivityIndicatorView {
	
	// MARK: - Internal Properties
	
	private(set) var isStart = false
	private(set) var isStop = false
	private(set) var isHiddenNow = false
	
	// MARK: - Override Properties
	
	override var isHidden: Bool {
		willSet {
			isHiddenNow = isHidden
		}
	}

	// MARK: - Override Methods
	
	override func startAnimating() {
		super.startAnimating()
		isStart = true
	}
	
	override func stopAnimating() {
		super.stopAnimating()
		isStop = true
	}
}
