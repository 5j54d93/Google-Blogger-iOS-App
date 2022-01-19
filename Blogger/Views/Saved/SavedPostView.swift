//
//  SavedPostView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct SavedPostView: View {
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @State private var showShareSheet = false
    @State private var savedInCoreData = false
    @State private var showMore = false
    @State private var authorName = ""
    @State private var postDate = Date()
    @State private var showDisplaySetting = false
    @State private var ScreenBright = 0.0
    @State private var showUnsaveAlert = false
    
    @Binding var readPost: Bool
    @Binding var postUrl: String
    
    var savedPost: SavedPost
    
    var body: some View {
        VStack {
            HStack {
                if let avatar = savedPost.avatar {
                    AsyncImage(url: URL(string: avatar.hasPrefix("https:") ? avatar : "https:" + avatar)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray.overlay { ProgressView() }
                    }
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                }
                if let author = savedPost.author, let published = savedPost.published {
                    ( Text(author) + Text(" in ") + Text(published, format: .dateTime.year().month().day()) )
                        .font(.subheadline).foregroundColor(colorScheme == .light ? .black : .white)
                }
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
                Button {
                    showUnsaveAlert = true
                } label: {
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .frame(maxWidth: .infinity)
                Button {
                    authorName = savedPost.author!
                    postDate = savedPost.published!
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
        .alert(isPresented: $showUnsaveAlert) {
            Alert(
                title: Text("Are you sure to unsave this post?"),
                primaryButton: .default(
                    Text("Yes"),
                    action: { readPost = false; deletePost(id: savedPost.id!) }
                ),
                secondaryButton: .destructive(
                    Text("Cancel"),
                    action: { showUnsaveAlert = false }
                )
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
    
    private func deletePost(id: String) {
        withAnimation {
            let request = SavedPost.fetchRequest() as NSFetchRequest<SavedPost>
            request.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let SavedPost = try viewContext.fetch(request)
                viewContext.delete(SavedPost[0])
                try viewContext.save()
            } catch {
            }
        }
    }
}

