//
//  MainCoordinatorTests.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 16.09.2021.
//

@testable import GitManager
import XCTest

class MainCoordinatorTests: XCTestCase {

    private var systemUnderTest: MainCoordinatorImpl!
    private var window: UIWindow!
    private var vcFactoryMock: MockViewControllerFactory!
    private var authServiceMock: MockAuthService!

    private typealias MockViewController = MockViewControllerFactory.MockViewController
    private typealias ViewCotrollerType = MockViewControllerFactory.ViewCotrollerType

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow(frame: .zero)
        vcFactoryMock = MockViewControllerFactory()
        authServiceMock = MockAuthService()
        systemUnderTest = MainCoordinatorImpl(window: window, vcFactory: vcFactoryMock, authService: authServiceMock)
    }

    override func tearDownWithError() throws {
        window = nil
        vcFactoryMock = nil
        authServiceMock = nil
        systemUnderTest = nil
        try super.tearDownWithError()
    }

    func testAuthVcIsDisplayedAfterStartMethodCalledIfNotAuthorized() throws {
        // act
        let sut = MainCoordinatorImpl(window: window, vcFactory: vcFactoryMock, authService: authServiceMock)
        authServiceMock.authToken = nil
        sut.start()

        let navigationVC = try XCTUnwrap(window.rootViewController as? UINavigationController)
        let testVC = try XCTUnwrap(navigationVC.viewControllers.first as? MockViewController)

        // assert
        XCTAssertEqual(testVC.vcType, .auth)
    }

    func testMainVcIsDisplayedAfterStartMethodCalledIfAuthorized() throws {
        // act
        let sut = MainCoordinatorImpl(window: window, vcFactory: vcFactoryMock, authService: authServiceMock)
        authServiceMock.authToken = "testToken"
        sut.start()

        let navigationVC = try XCTUnwrap(window.rootViewController as? UINavigationController)
        let tabBarVC = try XCTUnwrap(navigationVC.viewControllers.first as? UITabBarController)
        let viewControllers = try XCTUnwrap(tabBarVC.viewControllers as? [MockViewController])

        // assert
        for (index, element) in [ViewCotrollerType.reposList, ViewCotrollerType.currentUserProfile].enumerated() {
            XCTAssertEqual(viewControllers[index].vcType, element)
        }
    }

    func testAuthVcIsSetAfterAuthStateProvidedInCoordinateMethod() throws {
        // act
        systemUnderTest.start()
        systemUnderTest.coordinate(to: .auth)

        let navigationVC = try XCTUnwrap(window.rootViewController as? UINavigationController)
        let testVC = try XCTUnwrap(navigationVC.viewControllers.first as? MockViewController)

        // assert
        XCTAssertEqual(testVC.vcType, .auth)
    }

    func testMainVcIsSetAfterAuthStateProvidedInCoordinateMethod() throws {
        // act
        systemUnderTest.start()
        systemUnderTest.coordinate(to: .main)

        let navigationVC = try XCTUnwrap(window.rootViewController as? UINavigationController)
        let testVC = try XCTUnwrap(navigationVC.viewControllers.first as? MockViewController)

        // assert
        XCTAssertEqual(testVC.vcType, .auth)
    }
}
