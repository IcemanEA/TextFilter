//
//  FilterViewController.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import UIKit

final class FilterViewController: UIViewController {
	
	// MARK: - Publick properties
	
	var delegate: StringListViewControllerDelegate!
	
	// MARK: - Private properties
	
	private lazy var urlTextField: UITextField = makeTextField(with: L10n.StringsFilter.TextField.url)
	private lazy var filterTextField: UITextField = makeTextField(with: L10n.StringsFilter.TextField.filter)
	private lazy var applyButton: UIButton = makeButtonApply(
		with: L10n.StringsFilter.Button.apply,
		action: #selector(applyButtonPressed)
	)
	private lazy var cancelButton: UIButton = makeButtonApply(
		with: L10n.StringsFilter.Button.cancel,
		action: #selector(cancelButtonPressed)
	)
	
	private var networkManager: INetworkManager!
	
	// MARK: - Initialization
	
	convenience init(networkManager: INetworkManager) {
		self.init()
		self.networkManager = networkManager
	}
	
	// MARK: - Override methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Theme.backgroundColor
		
		setupSubviews(urlTextField, filterTextField, applyButton, cancelButton)
		layout()
	}
	
	// MARK: - Publick Methods
	
	func configure(with url: String, and filter: String) {
		urlTextField.text = url
		filterTextField.text = filter
	}
	
	// MARK: - Private Methods
	
	@objc
	private func applyButtonPressed() {
		guard let urlText = urlTextField.text, !urlText.isEmpty else {
			showAlert(L10n.StringsFilter.Warning.noUrL, isError: false)
			return
		}
		
		do {
			try networkManager.generateURL(from: urlText)
		} catch {
			showAlert(error.localizedDescription)
			return
		}
		
		delegate.reloadData(with: urlText, and: filterTextField.text ?? "")
		
		dismiss(animated: true)
	}
	
	@objc
	private func cancelButtonPressed() {
		dismiss(animated: true)
	}
}

// MARK: - Build interface items

private extension FilterViewController {
	
	func makeTextField(with placeholder: String? = nil) -> UITextField {
		let textField = UITextField()
		
		textField.placeholder = placeholder
		textField.backgroundColor = Theme.backgroundColor
		textField.textColor = Theme.mainColor
		textField.tintColor = Theme.mainColor
		textField.layer.borderWidth = Sizes.borderWidth
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Sizes.Padding.half, height: textField.frame.height))
		textField.leftViewMode = .always
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}
	
	func makeButtonApply(with title: String, action: Selector) -> UIButton {
		let button = UIButton(type: .system)
		
		button.setTitle(title, for: .normal)
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
		button.backgroundColor = Theme.mainColor
		button.tintColor = Theme.accentColor
		button.layer.cornerRadius = Sizes.cornerRadius
		
		button.addTarget(self, action: action, for: .touchUpInside)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}
	
	func setupSubviews(_ subviews: UIView...) {
		subviews.forEach { subview in
			view.addSubview(subview)
		}
	}
	
	func layout() {
		NSLayoutConstraint.activate(
			[
				urlTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				urlTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.Padding.double),
				urlTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 1),
				urlTextField.heightAnchor.constraint(equalToConstant: Sizes.L.height),
				
				filterTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				filterTextField.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: Sizes.Padding.normal),
				filterTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: 1),
				filterTextField.heightAnchor.constraint(equalToConstant: Sizes.L.height),
				
				applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				applyButton.topAnchor.constraint(equalTo: filterTextField.bottomAnchor, constant: Sizes.Padding.double),
				applyButton.widthAnchor.constraint(equalToConstant: Sizes.L.width),
				applyButton.heightAnchor.constraint(equalToConstant: Sizes.L.height),
				
				cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				cancelButton.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: Sizes.Padding.normal),
				cancelButton.widthAnchor.constraint(equalToConstant: Sizes.L.width),
				cancelButton.heightAnchor.constraint(equalToConstant: Sizes.L.height)
			]
		)
	}
	
	func showAlert(_ message: String, isError: Bool = true) {
		let title = isError ? L10n.Alert.Title.error : L10n.Alert.Title.warning
		let alert = UIAlertController.createAlertController(withTitle: title, and: message)
		
		let okAction = UIAlertAction(title: L10n.Alert.Button.ok, style: .default)
		alert.addAction(okAction)
		
		present(alert, animated: true)
	}
}
