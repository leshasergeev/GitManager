//
//  AuthService.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 13.09.2021.
//

import Foundation

protocol AuthService: AnyObject {
    var authToken: String? { get }
    var isAuthorized: Bool { get }
    func signIn(withToken token: String)
    func signOut()
}

class AuthServiceImpl: AuthService {
    private let secureStorage: SecureStorage

    var isAuthorized: Bool {
        authToken != nil
    }

    private(set) var authToken: String?

    private let keyForToken = "github-access-token"

    required init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
        authToken = try? secureStorage.getValue(forKey: keyForToken)
    }

    func signIn(withToken token: String) {
        do {
            try secureStorage.set(value: token, forKey: keyForToken)
            authToken = token
        } catch {
            authToken = nil
            try? secureStorage.set(value: nil, forKey: keyForToken)
        }
    }

    func signOut() {
        try? secureStorage.clearData()
        authToken = nil
    }
}
