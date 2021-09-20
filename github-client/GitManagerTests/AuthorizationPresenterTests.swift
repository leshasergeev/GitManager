//
//  AuthorizationPresenterTests.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 11.09.2021.
//

@testable import GitManager
import XCTest

class AuthorizationPresenterTests: XCTestCase {

    private var systemUnderTest: AuthorizationPresenterImpl!
    private var networkingMock: MockOAuthAuthorizationService!
    private var viewMock: MockView!
    private var authServiceMock: MockAuthService!
    private var coordinatorMock: MockCoordinator!
    private var window: UIWindow!
    private var vcFactoryMock: MockViewControllerFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        authServiceMock = MockAuthService()
        networkingMock = MockOAuthAuthorizationService()
        vcFactoryMock = MockViewControllerFactory()
        coordinatorMock = MockCoordinator(window: window, vcFactory: vcFactoryMock, authService: authServiceMock)
        systemUnderTest = AuthorizationPresenterImpl(networkService: networkingMock, authService: authServiceMock)
        viewMock = MockView()
        systemUnderTest.view = viewMock
        systemUnderTest.coordinator = coordinatorMock
    }

    override func tearDownWithError() throws {
        window = nil
        authServiceMock = nil
        networkingMock = nil
        vcFactoryMock = nil
        coordinatorMock = nil
        systemUnderTest = nil
        viewMock = nil
        try super.tearDownWithError()
    }

    func testViewsURLRequestToNullIfURLRequestIsNotProvided() {
        // arrange
        networkingMock.urlRequest = nil

        // act
        systemUnderTest.signInWithGitButtonTapped()

        // assert
        XCTAssertNil(viewMock.urlRequest)
        XCTAssertFalse(viewMock.isAuthWindowShown)
    }

    func testViewsURLRequestIfURLRequestProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "github.com/login/oauth/authorize?client_id=057e11fcbdd12c675c88&client_secret=11092021"))
        networkingMock.urlRequest = URLRequest(url: url)

        // act
        systemUnderTest.signInWithGitButtonTapped()

        // assert
        XCTAssertEqual(viewMock.urlRequest?.url?.absoluteString,
                       "github.com/login/oauth/authorize?client_id=057e11fcbdd12c675c88&client_secret=11092021")
        XCTAssertTrue(viewMock.isAuthWindowShown)
    }

    func testViewsNavigationToFalseIfBadURLProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "https://gitmanager?code=test"))

        // act
        let result = systemUnderTest.processNavigation(toUrl: url)

        // assert
        XCTAssertFalse(result)
    }

    func testNavigationToFalseIfNullIsProvided() {
        // act
        let result = systemUnderTest.processNavigation(toUrl: nil)

        // assert
        XCTAssertFalse(result)
    }

    func testNavigationToTrueIfCorrectUrlProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "com.ibamboola.gitmanager://autorization?code=test"))

        // act
        let result = systemUnderTest.processNavigation(toUrl: url)

        // assert
        XCTAssertTrue(result)
    }

    func testAuthCodeIfCorrectUrlProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "com.ibamboola.gitmanager://autorization?code=test&refresh_token=refresh"))

        // act
        _ = systemUnderTest.processNavigation(toUrl: url)

        // assert
        XCTAssertEqual(networkingMock.authCode, "test")
    }

    func testAccessTokenIsSetAfterCorrectUrlProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "com.ibamboola.gitmanager://autorization?code=test&refresh_token=refresh"))
        networkingMock.result = .success("testingToken")
        let expectation = XCTestExpectation(description: "token")
        networkingMock.expectation = expectation

        // act
        let result = systemUnderTest.processNavigation(toUrl: url)
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
        XCTAssertEqual(authServiceMock.authToken, "testingToken")
    }

    func testAuthTokenIsNilAfterInvalidURLProvided() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "com.ibamboola.gitmanager://someInvalidRequest"))
        networkingMock.result = .failure(NetworkError.invalidRequest)
        let expectation = XCTestExpectation(description: "bad URL provided")
        networkingMock.expectation = expectation

        // act
        let result = systemUnderTest.processNavigation(toUrl: url)
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
        XCTAssertNil(authServiceMock.authToken)
    }

    func testCoordinateToMainCalledIfSuccessfullySignedIn() throws {
        // arrange
        let url = try XCTUnwrap(URL(string: "com.ibamboola.gitmanager://autorization?code=test&refresh_token=refresh"))
        networkingMock.result = .success("testToken")

        // act
        _ = systemUnderTest.processNavigation(toUrl: url)
        networkingMock.finishDownload()
        // RunLoop.run для того, чтобы в AuthorizationPresenter.getToken выставил на main.async viewController
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(coordinatorMock.state, .main)
    }
}
