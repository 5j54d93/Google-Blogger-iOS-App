//
//  BloggerApp.swift
//  BloggerWatch WatchKit Extension
//
//  Created by 莊智凱 on 2022/1/11.
//

import SwiftUI
import CoreData

@main
struct BloggerApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TagView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
