//
//  Profile.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 19.09.2021.
//

import Foundation

struct UserProfile: Codable {

    let fullName: String?
    let accountName: String
    let avatarUrl: String
    let followers: Int
    let following: Int
    let company: String?
    let email: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case accountName = "login"
        case avatarUrl = "avatar_url"
        case followers, following, company, email, location
    }
}
