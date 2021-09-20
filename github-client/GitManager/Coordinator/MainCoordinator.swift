//
//  MainCoordinator.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 14.09.2021.
//

import UIKit

protocol MainCoordinator: AnyObject {
    func start()
    func coordinate(to state: MainCoordinatorState, animated: Bool)
    func coordinate(to state: MainCoordinatorState)
}

extension MainCoordinator {
    func coordinate(to state: MainCoordinatorState) {
        return coordinate(to: state, animated: true)
    }
}

enum MainCoordinatorState {
    case main, auth
}

class MainCoordinatorImpl: MainCoordinator {

    private var navigation: UINavigationController

    private let viewControllerFactory: ViewControllerFactory

    private let authService: AuthService

    private let window: UIWindow

    required init(window: UIWindow, vcFactory: ViewControllerFactory, authService: AuthService) {
        self.window = window
        self.viewControllerFactory = vcFactory
        self.authService = authService
        self.navigation = UINavigationController()
    }

    func start() {
        window.rootViewController = navigation

        let firstInteractiveVC: UIViewController
        if authService.isAuthorized {
            firstInteractiveVC = viewControllerFactory.buildMainViewController(withCoordinator: self)
        } else {
            firstInteractiveVC = viewControllerFactory.buildAuthorizationViewController(withCoordinator: self)
        }
        navigation.pushViewController(firstInteractiveVC, animated: false)

        window.makeKeyAndVisible()
    }

    func coordinate(to state: MainCoordinatorState, animated: Bool = true) {
        switch state {
        case .auth:
            let authVC = viewControllerFactory.buildAuthorizationViewController(withCoordinator: self)
            navigation.setViewControllers([authVC], animated: animated)
        case .main:
            let mainVC = viewControllerFactory.buildMainViewController(withCoordinator: self, animated: animated)
            navigation.setViewControllers([mainVC], animated: animated)
        }
    }
}
