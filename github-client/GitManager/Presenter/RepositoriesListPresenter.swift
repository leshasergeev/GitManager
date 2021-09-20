//
//  PresenterForListOfReps.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 09.08.2021.
//

import Foundation

protocol RepositoriesListPresenter: AnyObject {
    func elementsCount() -> Int
    func retrieveRepository(atIndex index: Int) -> Repository?
    func searchRepositories(withName name: String)
    func viewIsReady()
    func willDisplayItem(atIndex index: Int)
}

typealias Repository = RepositoriesListResponse.Repository

class RepositoriesListPresenterImpl: RepositoriesListPresenter {

    private var isNextPageLoading = false

    private var hasMoreData = true

    private var currentSearchRequest = ""

    weak var view: RepositoriesListView?

    weak var coordinator: MainCoordinator?

    private var listOfRepositories: [Repository] = []

    private let reposService: RepositoriesListsService

    required init(networkService: RepositoriesListsService) {
        self.reposService = networkService
    }

    func elementsCount() -> Int {
        return listOfRepositories.count
    }

    func retrieveRepository(atIndex index: Int) -> Repository? {
        if index >= 0 && index < listOfRepositories.count {
            return listOfRepositories[index]
        }
        return nil
    }

    func searchRepositories(withName name: String) {
        currentSearchRequest = name
        reposService.getRepositoriesList(for: name, pageNumber: 1) { [weak self] result in
            DispatchQueue.main.async {
                self?.processProvidedResultBy(appending: false, result: result)
            }
        }
    }

    func viewIsReady() {
        view?.state = .emptyRequest
    }

    private func requestNewPage() {
        let pageNumber = (elementsCount() / RepositoriesRequestQueryBuilder.elementsPerPage) + 1

        self.reposService.getRepositoriesList(for: self.currentSearchRequest, pageNumber: pageNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.processProvidedResultBy(appending: true, result: result)
            }
        }
    }

    private func processProvidedResultBy(appending: Bool, result: Result<RepositoriesListResponse, Error>) {
        switch result {
        case .success(let repositoriesResponse):
            if appending {
                self.listOfRepositories.append(contentsOf: repositoriesResponse.items)
            } else {
                self.listOfRepositories = repositoriesResponse.items
            }
            self.view?.updateListOfRepositories()
            if repositoriesResponse.items.isEmpty {
                self.view?.state = .placeholder
            } else {
                self.view?.state = .table
            }
            self.hasMoreData = repositoriesResponse.totalCount > self.elementsCount()
        case .failure(_):
            self.listOfRepositories.removeAll()
            self.currentSearchRequest = ""
            self.view?.updateListOfRepositories()
            self.view?.state = .error
        }
        self.isNextPageLoading = false
    }

    func willDisplayItem(atIndex index: Int) {
        if !isNextPageLoading, hasMoreData, index >= (elementsCount() - 4) {
            isNextPageLoading = true
            requestNewPage()
        }
    }
}
