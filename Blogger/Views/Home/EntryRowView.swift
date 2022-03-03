//
//  EntryRowView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct EntryRowView: View {
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @State private var savedInCoreData = false
    @State private var readPost = false
    @State private var readPostUrl = ""
    @State var entry: Entries
    
    var body: some View {
        Button {
            readPost = true
            entry.link.forEach { link in
                if link.rel == "alternate" {
                    readPostUrl = link.href
                }
            }
        } label: {
            VStack(alignment: .leading) {
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
                        Text(author.name.name)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.title.title).bold().font(.title3)
                        if let category = entry.category {
                            HStack {
                                ForEach(category.prefix(3), id: \.term) { category in
                                    Text(category.term)
                                }
                            }
                            .foregroundColor(.gray)
                            .padding(.vertical, 1)
                        } else {
                            Spacer().padding(.vertical, 1)
                        }
                        HStack {
                            Text(entry.published.published, format: .dateTime.year().month().day())
                            Spacer()
                            BookmarkView(entry: $entry)
                                .frame(width: 20, height: 20)
                                .onAppear {
                                    savedInCoreData = false
                                    SavedPosts.forEach { SavedPost in
                                        if entry.id.id == SavedPost.id! {
                                            savedInCoreData = true
                                        }
                                    }
                                    entry.isSave = savedInCoreData
                                }
                        }.foregroundColor(.gray)
                    }
                    if let thumbnail = entry.thumbnail {
                        let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
                        let fullResUrl = thumbnail.url[..<resVarId]
                        Spacer()
                        AsyncImage(url: URL(string: fullResUrl + "s480")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.overlay { ProgressView() }
                        }
                        .frame(width: 75, height: 75)
                        .clipped()
                        .padding(.leading)
                    }
                }
            }
        }.buttonStyle(.plain)
        .fullScreenCover(isPresented: $readPost) {
            PostView(readPost: $readPost, postUrl: $readPostUrl, entry: $entry)
        }
        .contextMenu {
            Button(action: {
                readPost = true
                entry.link.forEach { link in
                    if link.rel == "alternate" {
                        readPostUrl = link.href
                    }
                }
            }) { Label("Read", systemImage: "doc.richtext") }
            Button(action: {
                entry.link.forEach { link in
                    if link.rel == "alternate" {
                        readPostUrl = link.href
                    }
                }
                if entry.isSave == false {
                    entry.author.forEach { author in
                        addPost(author: author.name.name, avatar: author.avatar.src, id: entry.id.id, link: readPostUrl, published: entry.published.published, thumbnail: entry.thumbnail?.url, title: entry.title.title)
                    }
                    entry.isSave?.toggle()
                }
            }) { Label("Save", systemImage: "bookmark") }
            Button(role: .destructive) {
                if entry.isSave == true {
                    deletePost(id: entry.id.id)
                    entry.isSave?.toggle()
                }
            } label: {
                Label("Unsave", systemImage: "bookmark.slash")
            }
        }
    }
    
    private func addPost(author: String, avatar: String, id: String, link: String, published: Date, thumbnail: String?, title: String) {
        withAnimation {
            let newPost = SavedPost(context: viewContext)
            newPost.timestamp = Date()
            newPost.author = author
            newPost.avatar = avatar
            newPost.id = id
            newPost.link = link
            newPost.note = "Add a note..."
            newPost.published = published
            newPost.thumbnail = thumbnail
            newPost.title = title

            do {
                try viewContext.save()
            } catch {
            }
        }
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
