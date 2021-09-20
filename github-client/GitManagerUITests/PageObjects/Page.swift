//
//  Page.swift
//  GitManagerUITests
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import Foundation
import XCTest

protocol Page: AnyObject {
    var application: XCUIApplication { get }
    init(application: XCUIApplication)
}

class MainScreenPage: Page {
    var application: XCUIApplication

    private var repositoriesTabBar: XCUIElement {
        return application.tabBars.element(matching: .tabBar, identifier: "tabBar_main")
    }

    private var repositoriesTabBarItem: XCUIElement {
        return repositoriesTabBar.buttons.element(matching: .button, identifier: "tabBarItem_repositories")
    }

    required init(application: XCUIApplication) {
        self.application = application
    }

    func repositoriesItemTapped() -> RepositoriesPage {
        if repositoriesTabBarItem.waitForExistence(timeout: 10) {
            XCTAssertTrue(repositoriesTabBarItem.exists)
        }
        return RepositoriesPage(application: application)
    }
}
