//
//  MockOAuthAuthorizationService.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 12.09.2021.
//

import Foundation
@testable import GitManager
import XCTest

class MockOAuthAuthorizationService: OAuthAuthorizationService {

    var urlRequest: URLRequest?

    var authCode: String?

    var completion: ((Result<String, Error>) -> Void)?

    var result: Result<String, Error>?

    var expectation: XCTestExpectation?

    func buildAuthRequest() -> URLRequest? {
        return urlRequest
    }

    func getToken(withAuthCode authCode: String?, completion: @escaping(Result<String, Error>) -> Void) {
        self.authCode = authCode
        self.completion = completion
    }

    func finishDownload() {
        if let result = self.result {
            completion?(result)
            completion = nil
            expectation?.fulfill()
            expectation = nil
        }
    }
}
