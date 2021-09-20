//
//  KeychainWrapper.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 13.09.2021.
//

import Foundation

protocol SecureStorage {
    func set(value: String?, forKey key: String) throws
    func getValue(forKey key: String) throws -> String?
    func clearData() throws
}

enum SecureStorageError: Error {
    case unhandledError
}

class KeychainWrapper: SecureStorage {

    private let accountName: String

    required init(accountName: String) {
        self.accountName = accountName
    }

    func set(value: String?, forKey key: String) throws {
        if let value = value {
            guard let encodedToken = value.data(using: .utf8) else { return }
            let storingQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                               kSecAttrAccount as String: accountName,
                                               kSecAttrService as String: key,
                                               kSecValueData as String: encodedToken]
            let status = SecItemAdd(storingQuery as CFDictionary, nil)
            guard status == errSecSuccess else { throw SecureStorageError.unhandledError }
        } else {
            let wipingQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                              kSecAttrAccount as String: accountName,
                                              kSecAttrService as String: key]
            let status = SecItemDelete(wipingQuery as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound
            else { throw SecureStorageError.unhandledError }
        }
    }

    func getValue(forKey key: String) throws -> String? {
        let searchingQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                             kSecAttrService as String: key,
                                             kSecAttrAccount as String: accountName,
                                             kSecMatchLimit as String: kSecMatchLimitOne,
                                             kSecReturnAttributes as String: true,
                                             kSecReturnData as String: true]
        var retrievedItem: CFTypeRef?
        let status = SecItemCopyMatching(searchingQuery as CFDictionary, &retrievedItem)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw SecureStorageError.unhandledError }

        guard let item = retrievedItem as? [String: Any],
              let valueData = item[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: .utf8)
        else { return nil }

        return value
    }

    func clearData() throws {
        let wipingQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: accountName]
        let status = SecItemDelete(wipingQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound
        else { throw SecureStorageError.unhandledError }
    }
}
