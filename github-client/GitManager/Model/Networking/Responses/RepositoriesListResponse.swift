//
//  RepositoriesListResponse.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 11.08.2021.
//

import Foundation

struct RepositoriesListResponse: Codable {

    struct Repository: Codable {

        struct Owner: Codable {

            let ownersName: String
            let avatarURL: String

            enum CodingKeys: String, CodingKey {
                case avatarURL = "avatar_url"
                case ownersName = "login"
            }
        }

        let name: String
        let owner: Owner
        let description: String?
        let stars: Int
        let language: String?

        enum CodingKeys: String, CodingKey {
            case name, owner, description
            case stars = "stargazers_count"
            case language
        }
    }

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    let items: [Repository]
    let totalCount: Int
}
