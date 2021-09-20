//
//  ViewControllerFactory.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 03.09.2021.
//

import UIKit

protocol ViewControllerFactory {
    func buildRepositoriesListViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController
    func buildAuthorizationViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController
    func buildMainViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController
    func buildMainViewController(withCoordinator coordinator: MainCoordinator, animated: Bool) -> UIViewController
}

extension ViewControllerFactory {
    func buildMainViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController {
        return buildMainViewController(withCoordinator: coordinator, animated: false)
    }
}

class ViewControllerFactoryImpl: ViewControllerFactory {

    private let authService: AuthService

    private let storageManager: StorageManager

    required init(authService: AuthService, storageManager: StorageManager) {
        self.authService = authService
        self.storageManager = storageManager
    }

    func buildRepositoriesListViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController {
        let networkService = GitHubApiService(networking: URLSession.shared, authService: authService)
        let presenter = RepositoriesListPresenterImpl(networkService: networkService)
        let viewController = RepositoriesListViewController(presenter: presenter)
        presenter.view = viewController
        presenter.coordinator = coordinator
        return viewController
    }

    func buildAuthorizationViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController {
        let networkService = GitHubApiService(networking: URLSession.shared, authService: authService)
        let presenter = AuthorizationPresenterImpl(networkService: networkService, authService: authService)
        let authVC = AuthorizationViewController(presenter: presenter)
        presenter.view = authVC
        presenter.coordinator = coordinator
        return authVC
    }

    func buildCurrentUserProfileViewController(wiCoordinator coordinator: MainCoordinator) -> UIViewController {
        let networkService = GitHubApiService(networking: URLSession.shared, authService: authService)
        let presenter = CurrentUserProfilePresenterImpl(networkService: networkService,
                                                        authService: authService,
                                                        storageManager: storageManager)
        let currentUserProfileVC = CurrentUserProfileViewController(presenter: presenter)
        presenter.view = currentUserProfileVC
        presenter.coordinator = coordinator
        return currentUserProfileVC
    }

    func buildMainViewController(withCoordinator coordinator: MainCoordinator, animated: Bool = false) -> UIViewController {
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([
            buildRepositoriesListViewController(withCoordinator: coordinator),
            buildCurrentUserProfileViewController(wiCoordinator: coordinator)
        ], animated: animated)
        return tabBarVC
    }
}
