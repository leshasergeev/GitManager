//
//  SnapshotTesting.swift
//  GitManagerUITests
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import XCTest
@testable import GitManager
import SnapshotTesting

class SnapshotTesting: XCTestCase {
    
    private var systemUnderTest: AuthorizationViewController!
    private var authPresenterMock: MockAuthPresenter!
    

    override func setUpWithError() throws {
        try super.setUpWithError()

        authPresenterMock = MockAuthPresenter()
        systemUnderTest = AuthorizationViewController(presenter: authPresenterMock)

        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        authPresenterMock = nil
        systemUnderTest = nil
        
        try super.tearDownWithError()
    }

    func testMyViewController() {
        // assert
        assertSnapshot(matching: systemUnderTest, as: .image(on: .iPhoneSe))
    }

}
