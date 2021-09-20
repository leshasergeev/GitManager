//
//  CurrentUserProfilePresenter.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 17.09.2021.
//

import Foundation

protocol CurrentUserProfilePresenter: AnyObject {
    func signOutButtonTapped()
    func readyToPresentUserInfo()
}

class CurrentUserProfilePresenterImpl: CurrentUserProfilePresenter {
    weak var view: CurrentUserProfileView?

    weak var coordinator: MainCoordinator?

    private let networkService: UserInfoService

    private let authService: AuthService

    private let storageManager: StorageManager

    required init(networkService: GitHubApiService, authService: AuthService, storageManager: StorageManager) {
        self.networkService = networkService
        self.authService = authService
        self.storageManager = storageManager
    }

    func signOutButtonTapped() {
        authService.signOut()
        DispatchQueue.main.async {
            self.coordinator?.coordinate(to: .auth)
            self.storageManager.deleteData()
            WebCacheCleaner.clean()
        }
    }

    func readyToPresentUserInfo() {
        storageManager.getUserProfile { userProfile in
            if let profile = userProfile {
                DispatchQueue.main.async {
                    self.view?.setupViewWithProfile(profile)
                }
            } else {
                self.networkService.getUserProfile { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let userProfile):
                            self.storageManager.saveUserProfile(userProfile)
                            self.view?.setupViewWithProfile(userProfile)
                        case .failure(_):
                            self.view?.setupViewWithError()
                        }
                    }
                }
            }
        }
    }
}
