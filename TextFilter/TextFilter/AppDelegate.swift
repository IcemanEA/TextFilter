//
//  AppDelegate.swift
//  TextFilter
//
//  Created by Egor Ledkov on 01.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	private let networkManager: INetworkManager = NetworkManager()
	private let filesManager: IFilesManager = FilesManager()
	private let filterService: IFilterService = FilterService()
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		
		let stringListVC = StringListViewController(
			networkManager: networkManager,
			filesManager: filesManager,
			filterService: filterService
		)
		
		let navigationVC = UINavigationController(rootViewController: stringListVC)
		window?.rootViewController = navigationVC
		
		return true
	}
}

