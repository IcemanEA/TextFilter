//
//  UIAlertController+create.swift
//  TextFilter
//
//  Created by Egor Ledkov on 02.04.2023.
//

import Foundation

import UIKit

extension UIAlertController {
	
	static func createAlertController(withTitle title: String, and message: String) -> UIAlertController {
		UIAlertController(title: title, message: message, preferredStyle: .alert)
	}
}
