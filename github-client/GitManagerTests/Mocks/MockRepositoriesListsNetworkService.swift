//
//  MockRepositoriesListsNetworkService.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 18.08.2021.
//

@testable import GitManager
import XCTest

class MockRepositoriesListsNetworkService: RepositoriesListsService {

    var result: Result<RepositoriesListResponse, Error>?

    var completion: ((Result<RepositoriesListResponse, Error>) -> Void)?

    var name: String?

    func getRepositoriesList(for name: String,
                             pageNumber: Int,
                             completion: @escaping (Result<RepositoriesListResponse, Error>) -> Void) {
        self.name = name
        self.completion = completion
    }

    func finishDownload() {
        if let result = result {
            completion?(result)
            completion = nil
        }
    }
}
