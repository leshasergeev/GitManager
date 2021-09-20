//
//  MockAuthService.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 14.09.2021.
//

import Foundation
@testable import GitManager

class MockAuthService: AuthService {
    var authToken: String?

    var isAuthorized: Bool {
        authToken != nil
    }

    var errorOccured = false

    func signIn(withToken token: String) {
        if errorOccured {
            authToken = nil
        } else {
            authToken = token
        }
    }

    func signOut() {
        authToken = nil
    }
}
