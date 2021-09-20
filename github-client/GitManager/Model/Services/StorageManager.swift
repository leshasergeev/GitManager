//
//  CoreDataManager.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 20.09.2021.
//

import CoreData

protocol StorageManager {
    func saveUserProfile(_ userProfileResponse: UserProfile)
    func getUserProfile(_ completion: @escaping(UserProfile?) -> Void)
    func deleteData()
}

class StorageManagerImpl: StorageManager {

    private var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error { print(error) }
        }
        return container
    }

    private lazy var backgorundContext = container.newBackgroundContext()

    private lazy var context = container.viewContext

    func saveUserProfile(_ userProfileResponse: UserProfile) {
        backgorundContext.perform { [weak self] in
            guard let self = self else { return }
            let context = self.backgorundContext
            self.deleteProfiles(inContext: context)

            let moUserProfile = MOUserProfile(context: context)

            moUserProfile.accountName = userProfileResponse.accountName
            moUserProfile.avatarUrl = userProfileResponse.avatarUrl
            moUserProfile.company = userProfileResponse.company
            moUserProfile.email = userProfileResponse.email
            moUserProfile.followers = userProfileResponse.followers
            moUserProfile.following = userProfileResponse.following
            moUserProfile.fullName = userProfileResponse.fullName
            moUserProfile.location = userProfileResponse.location

            try? context.save()
        }
    }

    func getUserProfile(_ completion: @escaping(UserProfile?) -> Void) {
        context.performAndWait { [weak self] in
            guard self != nil else { return }
            let request: NSFetchRequest<MOUserProfile> = MOUserProfile.fetchRequest()
            guard let result = try? request.execute().first else {
                completion(nil)
                return
            }
            completion(result.getUserProfile())
        }
    }

    func deleteData() {
        backgorundContext.perform {
            let context = self.backgorundContext
            self.deleteProfiles(inContext: context)
            try? context.save()
        }
    }

    private func deleteProfiles(inContext context: NSManagedObjectContext) {
        let request: NSFetchRequest<MOUserProfile> = MOUserProfile.fetchRequest()
        guard let result = try? request.execute() else { return }
        result.forEach { context.delete($0) }
    }
}
