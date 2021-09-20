//
//  RepositoriesRequestQueryBuilder.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 11.08.2021.
//

import Foundation

class RepositoriesRequestQueryBuilder {

    struct Regulation {
        enum Key: String {
            case stars, forks, helpWantedIssues, updated
        }

        enum Direction: String {
            case asc, desc
        }

        var queryRegulation: [String: String] = [:]

        init(key: Key, direction: Direction? = nil) {
            self.queryRegulation["sort"] = key.rawValue
            if let order = direction {
                self.queryRegulation["order"] = order.rawValue
            }
        }
    }

    static func makeRepositoriesRequestQuery(name: String,
                                             language: String?,
                                             regulation: Regulation?,
                                             pageNumber: Int = 1) -> [URLQueryItem]? {
        guard !name.isEmpty else { return nil }

        var items: [String: String] = [:]

        if let lang = language, !lang.isEmpty {
            items["q"] = name + "+language:\(lang)"
        } else {
            items["q"] = name
        }

        regulation?.queryRegulation.forEach { items[$0.key] = $0.value }

        ["per_page": "\(elementsPerPage)", "page": "1"].forEach { items[$0.key] = $0.value }
        let queryItems = items.map { URLQueryItem(name: $0.key, value: $0.value) }

        return queryItems.sorted(by: { $0.name < $1.name })
    }
}

extension RepositoriesRequestQueryBuilder {
    static var elementsPerPage: Int { return 50 }
}
