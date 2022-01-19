//
//  ContentView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @StateObject var bloggerFeedViewModel = BloggerFeedViewModel()
    
    @State private var lastSelectTab = ""
    @State private var selectTab = 0
    @State private var backToTop = false
    
    var tabViewHandler: Binding<Int> { Binding (
        get: { self.selectTab },
        set: {
            if $0 == self.selectTab { backToTop.toggle() }
            self.selectTab = $0
        }
    )}
    
    var body: some View {
        TabView(selection: tabViewHandler) {
            HomeView(backToTop: $backToTop)
                .tabItem {
                    Image(systemName: selectTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)
                }.tag(0)
            ExploreView(backToTop: $backToTop)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(1)
            SavedView(backToTop: $backToTop, selectTab: $selectTab)
                .tabItem {
                    Image(systemName: selectTab == 2 ? "bookmark.fill" : "bookmark")
                        .environment(\.symbolVariants, .none)
                }.tag(2)
            AuthorView()
                .tabItem {
                    Image(systemName: selectTab == 3 ? "person.crop.circle.fill" : "person.crop.circle")
                        .environment(\.symbolVariants, .none)
                }.tag(3)
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
