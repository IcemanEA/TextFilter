//
//  StringListViewController.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import UIKit

protocol StringListViewControllerDelegate {
	func reloadData(with url: String, and filter: String)
}

final class StringListViewController: UITableViewController {

	// MARK: - Publick properties

	var activityIndicator: UIActivityIndicatorView!

	// MARK: - Private properties

	private let cellID = "stringCell"
	
	private var stringList: [String] = []
	private var url: String = NetworkLink.p500.rawValue
	private var filter: String = ""
	
	private var networkManager: INetworkManager!
	private var filesManager: IFilesManager!
	private var filterService: IFilterService!
	
	// MARK: - Initialization
	
	convenience init(networkManager: INetworkManager, filesManager: IFilesManager, filterService: IFilterService) {
		self.init()
		self.networkManager = networkManager
		self.filesManager = filesManager
		self.filterService = filterService
	}
	
	// MARK: - Override methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Theme.backgroundColor
		setupNavigitonBar()
		setupActivityIndicator()
		
		print("Simulator path for find result file:", filesManager.getPath())
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
	}
	
	// MARK: - Private Methods
	
	@objc
	private func openFilterPressed() {
		let filterVC = FilterViewController(networkManager: networkManager)
		filterVC.delegate = self
		filterVC.configure(with: url, and: filter)
		present(filterVC, animated: true)
	}
	
	private func fetchData() {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		navigationItem.rightBarButtonItem?.isEnabled = false
			
		networkManager.fetchData(from: url) { [weak self] result in
			switch result {
			case .success(let data):
				self?.convertToStrings(data: data)
			case .failure(let error):
				self?.showErrorAlert(error.localizedDescription)
			}
		}
	}
	
	private func convertToStrings(data: String) {
		do {
			stringList = try filterService.filteredFrom(string: data, with: filter)
			try saveToFile(stringList.joined(separator: "\n"))
		} catch {
			showErrorAlert(error.localizedDescription)
		}
		
		DispatchQueue.main.async {
			self.stopFetch()
			self.tableView.reloadData()
		}
	}
	
	private func saveToFile(_ string: String) throws {
		let data = string.data(using: .utf8) ?? Data()
		try filesManager.save(fileName: "results", dot: "log", data: data, isRewrite: true)
	}
	
	private func stopFetch() {
		activityIndicator.stopAnimating()
		navigationItem.rightBarButtonItem?.isEnabled = true
	}
}

// MARK: - Delegate

extension StringListViewController: StringListViewControllerDelegate {
	func reloadData(with url: String, and filter: String) {
		self.url = url
		self.filter = filter
		
		fetchData()
	}
}

// MARK: - TableView

extension StringListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		stringList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let string = stringList[indexPath.row]
		cell.textLabel?.text = string
		cell.textLabel?.textColor = Theme.mainColor
		
		return cell
	}
	
	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		if editingStyle == .delete {
			stringList.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let string = stringList[indexPath.row]
		
		let stringVC = StringViewController()
		stringVC.configure(with: string)
		show(stringVC, sender: nil)
	}
}

// MARK: - Build interface items

extension StringListViewController {
	
	private func setupNavigitonBar() {
		title = L10n.StringsFilter.title
		
		navigationController?.navigationBar.backgroundColor = Theme.mainColor
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.accentColor]
		navigationController?.navigationBar.tintColor = Theme.accentColor
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .search,
			target: self,
			action: #selector(openFilterPressed)
		)
	}
	
	private func setupActivityIndicator() {
		activityIndicator = UIActivityIndicatorView()
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(activityIndicator)
		
		NSLayoutConstraint.activate(
			[
				activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			]
		)
	}
	
	private func showErrorAlert(_ message: String) {
		DispatchQueue.main.async { [weak self] in
			let alert = UIAlertController.createAlertController(withTitle: L10n.Alert.Title.error, and: message)
			
			let okAction = UIAlertAction(title: L10n.Alert.Button.ok, style: .default)
			alert.addAction(okAction)
			
			self?.present(alert, animated: true)
		}
	}
}
