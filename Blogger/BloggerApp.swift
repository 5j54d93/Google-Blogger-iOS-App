//
//  BloggerApp.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI

@main
struct BloggerApp: App {
    
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferColorScheme == "System" ? .none : preferColorScheme == "Dark" ? .dark : .light)
        }
    }
}
