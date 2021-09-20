//
//  AppDelegate.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 06.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var coordinator: MainCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureInitialState()
        coordinator?.start()

        return true
    }

    private func configureInitialState() {
        let secureStorage = KeychainWrapper(accountName: Bundle.main.bundleIdentifier ?? "accountName")
        let authService = AuthServiceImpl(secureStorage: secureStorage)
        let storageManager = StorageManagerImpl()
        let viewControllerFactory = ViewControllerFactoryImpl(authService: authService,
                                                              storageManager: storageManager)
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            coordinator = MainCoordinatorImpl(
                window: window,
                vcFactory: viewControllerFactory,
                authService: authService
            )
        }
    }
}
