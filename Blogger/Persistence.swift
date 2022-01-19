//
//  Persistence.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newTag = Tag(context: viewContext)
            newTag.timestamp = Date()
            let newSavedPost = SavedPost(context: viewContext)
            newSavedPost.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Blogger")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
    }
}
