//
//  AuthServiceTests.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 14.09.2021.
//

@testable import GitManager
import XCTest

class AuthServiceTests: XCTestCase {

    private var systemUnderTest: AuthServiceImpl!
    private var secureStorageMock: SecureStorageMock!
    private let accountName = Bundle.main.bundleIdentifier ?? "accountName"
    private let keyForToken = "github-access-token"

    override func setUpWithError() throws {
        try super.setUpWithError()
        secureStorageMock = SecureStorageMock(accountName: accountName)
        systemUnderTest = AuthServiceImpl(secureStorage: secureStorageMock)
    }

    override func tearDownWithError() throws {
        secureStorageMock = nil
        systemUnderTest = nil
        try super.tearDownWithError()
    }

    func testAuthTokenIsSetAfterSuccesfullySignIn() {
        // arrange
        secureStorageMock.keychainStorage.removeAll()

        // act
        systemUnderTest.signIn(withToken: "testToken")

        // assert
        XCTAssertEqual(systemUnderTest.authToken, "testToken")
        XCTAssertTrue(systemUnderTest.isAuthorized)
    }

    func testTokenIsNullAfterErrorInSecureStorageOccured() {
        // arrange
        secureStorageMock.secureStorageError = .unhandledError

        // act
        systemUnderTest.signIn(withToken: "testToken")

        // assert
        XCTAssertNil(systemUnderTest.authToken)
        XCTAssertFalse(systemUnderTest.isAuthorized)
    }

    func testTokenIsNullAfterSignOutCalled() {
        // act
        systemUnderTest.signOut()

        // assert
        XCTAssertNil(systemUnderTest.authToken)
        XCTAssertEqual(secureStorageMock.clearDataCounter, 1)
    }

    func testAuthorizedAfterSignInWithEmptyToken() {
        // act
        systemUnderTest.signIn(withToken: "")

        // arrange
        XCTAssertEqual(systemUnderTest.authToken, "")
        XCTAssertTrue(systemUnderTest.isAuthorized)
    }

    func testOldTokenIsReplacedWithNewOneAfterSignIn() {
        // arrange
        systemUnderTest.signIn(withToken: "token1")

        // act
        systemUnderTest.signIn(withToken: "token2")

        // arrange
        XCTAssertTrue(systemUnderTest.isAuthorized)
        XCTAssertEqual(systemUnderTest.authToken, "token2")
    }

    func testTokenIsTakenFromStorageIfExistsInKeychain() {
        // arrange
        let secureStorage = SecureStorageMock(accountName: accountName, keychainStorage: [:])
        secureStorage.keychainStorage[keyForToken] = "tokenFromKeychain"
        let sut = AuthServiceImpl(secureStorage: secureStorage)

        // arrange
        XCTAssertEqual(secureStorage.getValueCounter, 1)
        XCTAssertEqual(sut.authToken, "tokenFromKeychain")
    }

    func testTokenIsNilIfDoesNotExistsInKeychain() {
        // arrange
        let secureStorage = SecureStorageMock(accountName: accountName, keychainStorage: [:])
        let sut = AuthServiceImpl(secureStorage: secureStorage)

        // arrange
        XCTAssertEqual(secureStorage.getValueCounter, 1)
        XCTAssertNil(sut.authToken)
    }
}
