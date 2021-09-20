//
//  MockView.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 19.08.2021.
//

import Foundation
@testable import GitManager

class MockView: RepositoriesListView {

    enum AlertState {
        case appear, notExist
    }

    var alertState = AlertState.notExist

    var state: RepositoriesListViewState = .error

    var isListUpdated = false

    var isAuthWindowShown = false

    var urlRequest: URLRequest?

    func updateListOfRepositories() {
        isListUpdated = true
    }
}

extension MockView: AuthorizationView {
    func showErrorNotification(withError error: Error) {
    }

    func showAuthorizationWindow(withURLRequest urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        isAuthWindowShown = true
    }
}
