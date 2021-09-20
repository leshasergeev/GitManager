//
//  MockPresenter.swift
//  GitManagerUITests
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import Foundation
@testable import GitManager

class MockAuthPresenter: AuthorizationPresenter {
    func signInWithGitButtonTapped() {
    }
    
    func processNavigation(toUrl url: URL?) -> Bool {
        return true
    }
}
