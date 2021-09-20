//
//  MOUserProfile+CoreDataProperties.swift
//  
//
//  Created by Aleksei Sergeev on 20.09.2021.
//
//

import CoreData
import Foundation

// swiftlint:disable extension_access_modifier
extension MOUserProfile {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<MOUserProfile> {
        return NSFetchRequest<MOUserProfile>(entityName: "MOUserProfile")
    }

    @NSManaged public var fullName: String?

    @NSManaged public var accountName: String

    @NSManaged public var avatarUrl: String

    @NSManaged public var followers: Int

    @NSManaged public var following: Int

    @NSManaged public var company: String?

    @NSManaged public var email: String?

    @NSManaged public var location: String?
}

extension MOUserProfile {
    func getUserProfile() -> UserProfile {
        return UserProfile(fullName: self.fullName,
                           accountName: self.accountName,
                           avatarUrl: self.avatarUrl,
                           followers: self.followers,
                           following: self.following,
                           company: self.company,
                           email: self.email,
                           location: self.location)
    }
}
