//
//  RepositoriesListPresenterTest.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 18.08.2021.
//

@testable import GitManager
import XCTest

class RepositoriesListPresenterTest: XCTestCase {

    private var systemUnderTest: RepositoriesListPresenterImpl!
    private var repositoriesListsNetworkServiceMock: MockRepositoriesListsNetworkService!
    private var viewMock: MockView!

    private enum PresenterErrors: Error {
        case someError
    }

    private typealias Owner = RepositoriesListResponse.Repository.Owner

    override func setUpWithError() throws {
        try super.setUpWithError()
        repositoriesListsNetworkServiceMock = MockRepositoriesListsNetworkService()
        systemUnderTest = RepositoriesListPresenterImpl(networkService: repositoriesListsNetworkServiceMock)
        viewMock = MockView()
        systemUnderTest.view = viewMock
    }

    override func tearDownWithError() throws {
        viewMock        = nil
        systemUnderTest = nil
        repositoriesListsNetworkServiceMock = nil
        try super.tearDownWithError()
    }

    private func makeRepositories<T: RangeReplaceableCollection>(withNames names: T) -> [Repository]
    where T.Element == String {
        names.map { RepositoriesListResponse.Repository(name: $0,
                                                        owner: Owner(ownersName: "",
                                                                     avatarURL: ""),
                                                        description: nil,
                                                        stars: 1,
                                                        language: nil)
        }
    }

    func testRepositoriesCountIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(systemUnderTest.elementsCount(), 3)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testZeroRepositoriesIfBadNameProvided() {
        // arrange
        let repositoriesNames: [RepositoriesListResponse.Repository] = []
        repositoriesListsNetworkServiceMock.result = .success(RepositoriesListResponse(items: repositoriesNames,
                                                                                       totalCount: repositoriesNames.count))

        // act
        systemUnderTest.searchRepositories(withName: "faifoijqiofiq")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(systemUnderTest.elementsCount(), 0)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testNameAtConcreteIndexIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        ["tetris1", "teteris2", "tetris3"].enumerated()
            .forEach { XCTAssertEqual(systemUnderTest.retrieveRepository(atIndex: $0.offset)?.name, $0.element) }
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testNullAtIndexThatExeededLimitsIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertNil(systemUnderTest.retrieveRepository(atIndex: 100))
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testNullAtIndexThatLessLimitsIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertNil(systemUnderTest.retrieveRepository(atIndex: -1))
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testNameIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(repositoriesListsNetworkServiceMock.name, "tetris")
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testViewStateIfStateProvided() {
        // act
        systemUnderTest.viewIsReady()

        // assert
        XCTAssertEqual(viewMock.state, .emptyRequest)
    }

    func testViewsTableStateIfCorrectNameProvided() {
        // arrange
        let repositoriesNames = ["tetris1", "teteris2", "tetris3"]
        let repos = makeRepositories(withNames: repositoriesNames)

        let repositoriesListResponce = RepositoriesListResponse(items: repos, totalCount: repositoriesNames.count)

        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(viewMock.state, .table)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testViewsErrorStateIfNameProvided() {
        // arrange
        repositoriesListsNetworkServiceMock.result = .failure(PresenterErrors.someError)

        // act
        systemUnderTest.searchRepositories(withName: "thsadhads oaisd kads")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(viewMock.state, .error)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testViewsEmptyStateIfCorrectNameProvided() {
        // arrange
        let repositoriesNames: [RepositoriesListResponse.Repository] = []
        repositoriesListsNetworkServiceMock.result = .success(RepositoriesListResponse(items: repositoriesNames,
                                                                                       totalCount: repositoriesNames.count))

        // act
        systemUnderTest.searchRepositories(withName: "tetris")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(viewMock.state, .placeholder)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testErrorStateIfEmptyNameStrProvided() {
        // arrange
        repositoriesListsNetworkServiceMock.result = .failure(NetworkError.invalidRequest)

        // act
        systemUnderTest.searchRepositories(withName: "")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(viewMock.state, .error)
        XCTAssertTrue(viewMock.isListUpdated)
    }

    func testZeroRepositoriesIfErrorReceived() {
        // arrange
        repositoriesListsNetworkServiceMock.result = .failure(NetworkError.invalidRequest)

        // act
        systemUnderTest.searchRepositories(withName: "")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        XCTAssertEqual(systemUnderTest.elementsCount(), 0)
        XCTAssertTrue(viewMock.isListUpdated)
	}

    func testElementsIfTwoPagesProvided() {
        // arrange
        let fullRepositoriesList = [
            "name1", "name2", "name3", "name4", "name5", "name6",
            "name7", "name8", "name9", "name10", "name11", "name12"
        ]

        let page1 = makeRepositories(withNames: fullRepositoriesList.prefix(6))
        let page2 = makeRepositories(withNames: fullRepositoriesList.suffix(6))

        // act
        var repositoriesListResponce = RepositoriesListResponse(items: page1, totalCount: fullRepositoriesList.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        systemUnderTest.searchRepositories(withName: "name")
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        repositoriesListResponce = RepositoriesListResponse(items: page2, totalCount: fullRepositoriesList.count)
        repositoriesListsNetworkServiceMock.result = .success(repositoriesListResponce)

        systemUnderTest.willDisplayItem(atIndex: page1.count - 3)
        repositoriesListsNetworkServiceMock.finishDownload()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))

        // assert
        fullRepositoriesList.enumerated().forEach { XCTAssertEqual(systemUnderTest.retrieveRepository(atIndex: $0.offset)?.name,
                                                                   $0.element)
        }
        XCTAssertTrue(viewMock.isListUpdated)
    }
}
