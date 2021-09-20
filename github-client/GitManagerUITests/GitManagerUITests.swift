//
//  GitManagerUITests.swift
//  GitManagerUITests
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import XCTest

class GitManagerUITests: XCTestCase {

    func testCellTappedAfterSearchingInSearchBar() throws {
        // act
        let application = XCUIApplication()
        application.launch()

        // assert
        let mainScreePage = MainScreenPage(application: application)
        mainScreePage
            .repositoriesItemTapped()
            .repositoriesCellTapped { XCTAssertTrue($0) }
    }
}
