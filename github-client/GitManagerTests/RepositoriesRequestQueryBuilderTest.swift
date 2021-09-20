//
//  RepositoriesRequestQueryBuilderTest.swift
//  GitManagerTests
//
//  Created by Aleksei Sergeev on 20.08.2021.
//

@testable import GitManager
import XCTest

class RepositoriesRequestQueryBuilderTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testQueryItemsIfOnlyNameProvided() throws {
        // act
        let builtQueryItems = try XCTUnwrap(RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "tetris",
                                                                              language: nil,
                                                                              regulation: nil)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        }))

        // assert
        XCTAssertEqual(builtQueryItems, ["q": "tetris", "per_page": "50", "page": "1"])
    }

    func testQueryItemsIfAllVariabelsProvided() throws {
        // arrange
        let key = RepositoriesRequestQueryBuilder.Regulation.Key.forks
        let direction = RepositoriesRequestQueryBuilder.Regulation.Direction.asc

        // act
        let builtQueryItems = try XCTUnwrap(RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "tetris",
                                                                              language: "swift",
                                                                              regulation: .init(key: key, direction: direction),
                                                                              pageNumber: 1)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        }))

        // assert
        XCTAssertEqual(builtQueryItems, ["q": "tetris+language:swift", "sort": "forks", "order": "asc", "per_page": "50", "page": "1"])
    }

    func testNullIfEmptyNameStrProvided() throws {
        // act
        let builtQueryItems = RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "",
                                                                              language: nil,
                                                                              regulation: nil)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        })

        // assert
        XCTAssertNil(builtQueryItems)
    }

    func testNullIfEmptyLanguageStrProvided() throws {
        // act
        let builtQueryItems = try XCTUnwrap(RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "tetris",
                                                                              language: "",
                                                                              regulation: nil)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        }))

        // assert
        XCTAssertEqual(builtQueryItems, ["q": "tetris", "per_page": "50", "page": "1"])
    }

    func testRegulationKeyIfOnlyKeyProvided() {
        // arrange
        let key = RepositoriesRequestQueryBuilder.Regulation.Key.stars

        // act
        let regulation = RepositoriesRequestQueryBuilder.Regulation(key: key, direction: nil)

        // assert
        XCTAssertEqual(regulation.queryRegulation, ["sort": "stars"])
    }

    func testRegulationIfKeyAndDirectionProvided() {
        // arrange
        let key = RepositoriesRequestQueryBuilder.Regulation.Key.stars
        let direction = RepositoriesRequestQueryBuilder.Regulation.Direction.desc

        // act
        let regulation = RepositoriesRequestQueryBuilder.Regulation(key: key, direction: direction)

        // assert
        XCTAssertEqual(regulation.queryRegulation, ["sort": "stars", "order": "desc"])
	}

    func testPageIfPageProvided() throws {
        // act
        let builtQueryItems = try XCTUnwrap(RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "tetris",
                                                                              language: nil,
                                                                              regulation: nil,
                                                                              pageNumber: 1)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        }))

        // assert
        XCTAssertEqual(builtQueryItems, ["q": "tetris", "per_page": "50", "page": "1"])
    }

    func testOnePageIfUncorrectPageProvided() throws {
        // act
        let builtQueryItems = try XCTUnwrap(RepositoriesRequestQueryBuilder
                                                .makeRepositoriesRequestQuery(name: "tetris",
                                                                              language: nil,
                                                                              regulation: nil,
                                                                              pageNumber: -1)?
                                                .reduce(into: [:], { queryItems, urlQItem in
                queryItems[urlQItem.name] = urlQItem.value
        }))

        // assert
        XCTAssertEqual(builtQueryItems, ["q": "tetris", "per_page": "50", "page": "1"])
    }
}
