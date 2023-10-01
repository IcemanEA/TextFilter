//
//  StringViewController.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import UIKit

final class StringViewController: UIViewController {
	
	// MARK: - Private properties
	
	private lazy var stringTextView = makeTextView()
	
	// MARK: - Override methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Theme.backgroundColor
		
		view.addSubview(stringTextView)
		layout()
	}
	
	// MARK: - Publick Methods
	
	func configure(with string: String) {
		stringTextView.text = string
	}
}

// MARK: - Build interface items

private extension StringViewController {
	
	func makeTextView() -> UITextView {
		let textView = UITextView()
		
		textView.backgroundColor = Theme.backgroundColor
		textView.textColor = Theme.mainColor
		textView.font = UIFont.preferredFont(forTextStyle: .body)
		
		textView.translatesAutoresizingMaskIntoConstraints = false
		
		return textView
	}
	
	func layout() {
		NSLayoutConstraint.activate(
			[
				stringTextView.topAnchor.constraint(equalTo: view.topAnchor),
				stringTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.quarter),
				stringTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.quarter),
				stringTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		)
	}
}
