//
//  BloggerApp.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI

@main
struct BloggerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
