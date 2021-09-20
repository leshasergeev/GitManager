//
//  RepositiriesPage.swift
//  GitManagerUITests
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import Foundation
import XCTest

class RepositoriesPage: Page {
    var application: XCUIApplication

    private var repositoriesSearchBar: XCUIElement {
        return application.searchFields.element(matching: .searchField, identifier: "searchBar_repos")
    }

    private var repositoriesTable: XCUIElement {
        return application.tables.element(matching: .table, identifier: "table_ListOfReps")
    }

    private var repositoriesTableCell: XCUIElement {
        return repositoriesTable.cells.element(matching: .cell, identifier: "cell_0")
    }

    required init(application: XCUIApplication) {
        self.application = application
    }

    func repositoriesCellTapped(completion: @escaping((Bool) -> Void)) {
        if repositoriesSearchBar.waitForExistence(timeout: 10) {
            repositoriesSearchBar.tap()
            repositoriesSearchBar.typeText("git")
            if repositoriesTableCell.waitForExistence(timeout: 10) {
                completion(repositoriesTableCell.exists)
            }
        }
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
    }
}
