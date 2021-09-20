//
//  AuthorizationPresenter.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 03.09.2021.
//

import Foundation
import WebKit

protocol AuthorizationPresenter: AnyObject {
    func signInWithGitButtonTapped()
    func processNavigation(toUrl url: URL?) -> Bool
}

class AuthorizationPresenterImpl: AuthorizationPresenter {
    weak var view: AuthorizationView?

    weak var coordinator: MainCoordinator?

    private let networkService: OAuthAuthorizationService

    private let authService: AuthService

    required init(networkService: OAuthAuthorizationService, authService: AuthService) {
        self.networkService = networkService
        self.authService = authService
    }

    func signInWithGitButtonTapped() {
        guard let urlRequest = networkService.buildAuthRequest() else { return }
        view?.showAuthorizationWindow(withURLRequest: urlRequest)
    }

    func processNavigation(toUrl url: URL?) -> Bool {
        guard url?.scheme == "com.ibamboola.gitmanager",
              let urlStr = url?.absoluteString else { return false }
        let urlComponents = URLComponents(string: urlStr)
        if let authCode = urlComponents?.queryItems?.first(where: { $0.name == "code" })?.value {
            getToken(withAuthCode: authCode)
        }
        return true
    }

    private func getToken(withAuthCode authCode: String) {
        networkService.getToken(withAuthCode: authCode) { result in
            switch result {
            case .success(let strToken):
                self.authService.signIn(withToken: strToken)
                if self.authService.isAuthorized {
                    DispatchQueue.main.async {
                        self.coordinator?.coordinate(to: .main)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
}
