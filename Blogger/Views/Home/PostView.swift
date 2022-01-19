//
//  PostView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct PostView: View {
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showShareSheet = false
    @State private var savedInCoreData = false
    @State private var showMore = false
    @State private var authorName = ""
    @State private var postDate = Date()
    @State private var showDisplaySetting = false
    @State private var ScreenBright = 0.0
    
    @Binding var readPost: Bool
    @Binding var postUrl: String
    @Binding var entry: Entries
    
    var body: some View {
        VStack {
            HStack {
                ForEach(entry.author, id: \.avatar.src) { author in
                    HStack {
                        AsyncImage(url: URL(string: author.avatar.src.hasPrefix("https:") ? author.avatar.src : "https:" + author.avatar.src)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray.overlay { ProgressView() }
                        }
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    }
                }
                ( Text(authorName) + Text(" in ") + Text(postDate, format: .dateTime.year().month().day()) )
                    .font(.subheadline).foregroundColor(colorScheme == .light ? .black : .white)
                Spacer()
                Button {
                    readPost = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            BrowserView(url: $postUrl)
            Spacer()
            
            HStack {
                Button {
                    if postUrl.hasSuffix("#comments") {
                        postUrl = String(postUrl.dropLast(9))
                        postUrl += "#comments"
                    } else {
                        postUrl += "#comments"
                    }
                } label: {
                    Image(systemName: "message")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .frame(maxWidth: .infinity)
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .frame(maxWidth: .infinity)
                BookmarkView(entry: $entry)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.accentColor)
                    .onAppear {
                        savedInCoreData = false
                        SavedPosts.forEach { SavedPost in
                            if entry.id.id == SavedPost.id! {
                                savedInCoreData = true
                            }
                        }
                        entry.isSave = savedInCoreData
                    }
                Button {
                    entry.author.forEach { author in
                        authorName = author.name.name
                    }
                    postDate = entry.published.published
                    showMore = true
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 5)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [URL(string: postUrl) ?? postUrl])
        }
        .actionSheet(isPresented: $showMore) {
            ActionSheet(
                title: Text("Author: \(authorName)"),
                message: ( Text("Post on: ") + Text(postDate, format: .dateTime.year().month().day()) ),
                buttons: [
                    .default(
                        Text("Display Setting"),
                        action: { showDisplaySetting = true }
                    ),
                    .default(
                        Text("Comment"),
                        action: {
                            if postUrl.hasSuffix("#comments") {
                                postUrl = String(postUrl.dropLast(9))
                                postUrl += "#comments"
                            } else {
                                postUrl += "#comments"
                            }
                        }
                    ),
                    .default(
                        Text("Share"),
                        action: { showShareSheet = true }
                    ),
                    .cancel()
                ]
            )
        }
        .bottomSheet(isPresented: $showDisplaySetting) {
            VStack {
                Text("Display Settings")
                    .bold()
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Button {
                            showDisplaySetting = false
                        } label: {
                            Text(Image(systemName: "xmark"))
                                .bold()
                                .font(.title3)
                        }
                        , alignment: .leading
                    )
                Divider()
                HStack {
                    Text(Image(systemName: "sun.max"))
                    Slider(value: $ScreenBright, in: 0...1)
                        .onAppear {
                            ScreenBright = UIScreen.main.brightness
                        }
                        .onChange(of: UIScreen.main.brightness) { _ in
                            ScreenBright = UIScreen.main.brightness
                        }
                    Text(Image(systemName: "sun.max"))
                }
                Divider()
                HStack {
                    Text("Appearance")
                    Spacer()
                    Picker(selection: $preferColorScheme) {
                        Text("System").tag("System")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    } label: {
                        Text("Appearance")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                }
                Spacer()
            }
            .padding()
        }
        .onChange(of: ScreenBright) { _ in
            UIScreen.main.brightness = ScreenBright
        }
        .preferredColorScheme(preferColorScheme == "System" ? colorScheme : preferColorScheme == "Dark" ? .dark : .light)
    }
}
