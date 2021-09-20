//
//  KeychainWrapperMock.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 14.09.2021.
//

import Foundation
@testable import GitManager

class SecureStorageMock: SecureStorage {
    var accountName: String

    var secureStorageError: SecureStorageError?

    var keychainStorage: [String: Any] = [:]

    var clearDataCounter = 0

    var setCounter = 0

    var getValueCounter = 0

    required init(accountName: String) {
        self.accountName = accountName
    }

    convenience init(accountName: String, keychainStorage: [String: Any]) {
        self.init(accountName: accountName)
        self.keychainStorage = keychainStorage
    }

    func set(value: String?, forKey key: String) throws {
        setCounter += 1
        if let error = secureStorageError { throw error }
        keychainStorage[key] = value
    }

    func getValue(forKey key: String) throws -> String? {
        getValueCounter += 1
        if let error = secureStorageError { throw error }
        guard let value = keychainStorage[key] as? String else { return nil }
        return value
    }

    func clearData() throws {
        clearDataCounter += 1
        if let error = secureStorageError { throw error }
        keychainStorage.removeAll()
    }
}
