//
//  NetworkServiceTests.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 18.08.2021.
//

@testable import GitManager
import XCTest

class NetworkServiceTests: XCTestCase {

    private var systemUnderTest: GitHubApiService!
    private var networkingMock: MockNetworking!
    private var authServiceMock: MockAuthService!

    private enum TestError: Error { case testError }

    private struct JSONTokenResponse: Codable {
        let accessToken = "Token"
        let scope = "repo,gist"
        let tokenType = "bearer"

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case scope
            case tokenType = "token_type"
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        authServiceMock = MockAuthService()
        networkingMock  = MockNetworking()
        systemUnderTest = GitHubApiService(networking: networkingMock, authService: authServiceMock)
    }

    override func tearDownWithError() throws {
        networkingMock  = nil
        systemUnderTest = nil
        try super.tearDownWithError()
    }

    func testCompareRequestsIfRequestProvided() throws {
        // arrange
        networkingMock.result = .failure(NetworkError.parsingError)
        let expectation = XCTestExpectation(description: "request")

        // act
        systemUnderTest.getRepositoriesList(for: "tetris") { _ in
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(networkingMock.request?.url?.absoluteString,
                       "https://api.github.com/search/repositories?order=desc&page=1&per_page=50&q=tetris&sort=stars")
    }

    func testListOfReposIfCorrectRequestProvided() throws {
        // arrange
        let jsonResponseURL = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "TetrisJSONResponse",
                                                                       withExtension: "json"))
        let correctResponse = try Data(contentsOf: jsonResponseURL)
        networkingMock.result = .success(correctResponse)

        var receivedRepositories: [String]?

        let expectation = XCTestExpectation(description: "request")

        // act
        systemUnderTest.getRepositoriesList(for: "tetris") { result in
            switch result {
            case .success(let receivedRepositoriesList):
                receivedRepositories = receivedRepositoriesList.items.map { $0.name }
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedRepositories, ["react-tetris", "vue-tetris", "hextris"])
    }

    func testParsingErrorIfBadDataReceived() throws {
        // arrange
        networkingMock.result = .success(Data())
        let expectation = XCTestExpectation(description: "parsingError")
        var receivedError: NetworkError?

        // act
        systemUnderTest.getRepositoriesList(for: "tetris") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                receivedError = error as? NetworkError
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedError, NetworkError.parsingError)
    }

    func testErrorIfTestErrorProvided() throws {
        // arrange
        networkingMock.result = .failure(TestError.testError)
        let expectation = XCTestExpectation(description: "testError")

        var receivedError: TestError?

        // act
        systemUnderTest.getRepositoriesList(for: "tetris") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                receivedError = error as? TestError
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedError, TestError.testError)
    }

    private func makeUrlComponents(fromUrlRequest urlRequest: URLRequest?) throws -> URLComponents {
        let url = try XCTUnwrap(urlRequest?.url)
        return try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
    }

    func testRequestIfRequestBuilderCalled() throws {
        // act
        let urlComponents = try makeUrlComponents(fromUrlRequest: systemUnderTest.buildAuthRequest())

        // assert
        XCTAssertEqual(urlComponents.scheme, "https")
        XCTAssertEqual(urlComponents.host, "github.com")
        XCTAssertEqual(urlComponents.path, "/login/oauth/authorize")
        XCTAssertEqual(urlComponents.queryItems?.first(where: { $0.name == "client_id" })?.value, "057e11fcbdd12c675c88")
    }

    func testParsingErrorIfNullInsteadOfAuthCodeProvided() throws {
        // arrange
        var receivedError: NetworkError?

        // act
        systemUnderTest.getToken(withAuthCode: nil) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                receivedError = error as? NetworkError
            }
        }

        // assert
        XCTAssertEqual(receivedError, NetworkError.parsingError)
    }

    func testRequestIfAuthCodeProvided() throws {
        // act
        systemUnderTest.getToken(withAuthCode: "testingCode", completion: { _ in })
        let urlComponents = try makeUrlComponents(fromUrlRequest: networkingMock.request)

        // assert
        XCTAssertEqual(urlComponents.scheme, "https")
        XCTAssertEqual(urlComponents.host, "github.com")
        XCTAssertEqual(urlComponents.path, "/login/oauth/access_token")
        XCTAssertEqual(urlComponents.queryItems?.first(where: { $0.name == "client_id" })?.value,
                       "057e11fcbdd12c675c88")
        XCTAssertEqual(urlComponents.queryItems?.first(where: { $0.name == "client_secret" })?.value,
                       "19bc7b6764f948cb3e60e1b65dadd9fe77bdf370")
        XCTAssertEqual(urlComponents.queryItems?.first(where: { $0.name == "code" })?.value,
                       "testingCode")
        XCTAssertEqual(networkingMock.request?.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testTestErrorIfBadAuthCodeProvided() {
        // arrange
        networkingMock.result = .failure(TestError.testError)
        let expectation = XCTestExpectation(description: "Bad Testing Name")
        var receivedError: TestError?

        // act
        systemUnderTest.getToken(withAuthCode: "badTestingCode") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                receivedError = error as? TestError
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedError, TestError.testError)
    }

    func testTestErrorIfBadDataReceived() throws {
        // arrange
        networkingMock.result = .success(try JSONEncoder().encode("badString"))
        let expectation = XCTestExpectation(description: "Getting Token")
        var receivedError: NetworkError?

        // act
        systemUnderTest.getToken(withAuthCode: "testingCode") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                receivedError = error as? NetworkError
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedError, NetworkError.parsingError)
    }

    func testTokenIfCorrectAuthCodeProvided() throws {
        // arrange
        networkingMock.result = .success(try JSONEncoder().encode(JSONTokenResponse()))
        let expectation = XCTestExpectation(description: "Getting Token")
        var receivedToken: String?

        // act
        systemUnderTest.getToken(withAuthCode: "testingCode") { result in
            switch result {
            case .success(let str):
                receivedToken = str
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        networkingMock.finishDownload()

        // assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedToken, "Token")
    }

    func testTokenIsAddedToReposRequestIfTokenExistsInAuthServer() throws {
        // arrange
        authServiceMock.authToken = "testToken"

        // act
        systemUnderTest.getRepositoriesList(for: "test", completion: { _ in })
        networkingMock.finishDownload()

        // assert
        XCTAssertEqual(networkingMock.request?.value(forHTTPHeaderField: "Authorization"), "token testToken")
    }

    func testReposRequestWithoutTokenIfTokenDoesNotInAuthServer() throws {
        // arrange
        authServiceMock.authToken = nil

        // act
        systemUnderTest.getRepositoriesList(for: "test", completion: { _ in })
        networkingMock.finishDownload()

        // assert
        let request = try XCTUnwrap(networkingMock.request)
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
    }
}
