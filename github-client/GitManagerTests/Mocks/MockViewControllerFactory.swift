//
//  MockViewControllerFactory.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 16.09.2021.
//

import Foundation
@testable import GitManager
import UIKit

class MockViewControllerFactory: ViewControllerFactory {

    enum ViewCotrollerType {
        case auth, reposList, currentUserProfile
    }

    class MockViewController: UIViewController {
        let vcType: ViewCotrollerType
        init(vcType: ViewCotrollerType) {
            self.vcType = vcType
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    func buildRepositoriesListViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController {
        return MockViewController(vcType: .reposList)
    }

    func buildAuthorizationViewController(withCoordinator coordinator: MainCoordinator) -> UIViewController {
        return MockViewController(vcType: .auth)
    }

    func buildMainViewController(withCoordinator coordinator: MainCoordinator, animated: Bool = false) -> UIViewController {
        let mainVC = UITabBarController()
        mainVC.setViewControllers([
            MockViewController(vcType: .reposList),
            MockViewController(vcType: .currentUserProfile)
        ], animated: animated)
        return mainVC
    }
}
