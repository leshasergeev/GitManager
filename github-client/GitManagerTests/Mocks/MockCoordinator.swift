//
//  MockCoordinator.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 16.09.2021.
//

import Foundation
@testable import GitManager
import UIKit

class MockCoordinator: MainCoordinator {

    var window: UIWindow

    var vcFactory: ViewControllerFactory

    var navigation: UINavigationController

    var authService: AuthService

    var startCounter = 0

    var state: MainCoordinatorState?

    required init(window: UIWindow, vcFactory: ViewControllerFactory, authService: AuthService) {
        navigation = UINavigationController()
        self.vcFactory = vcFactory
        self.authService = authService
        self.window = window
    }

    func start() {
        startCounter += 1
    }

    func coordinate(to state: MainCoordinatorState, animated: Bool) {
        self.state = state
    }
}
