//
//  BookmarkView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct BookmarkView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @State private var readPostUrl = ""
    
    @Binding var entry: Entries
    
    var body: some View {
        Button  {
            if entry.isSave == true {
                deletePost(id: entry.id.id)
            } else {
                entry.link.forEach { link in
                    if link.rel == "alternate" {
                        readPostUrl = link.href
                    }
                }
                entry.author.forEach { author in
                    addPost(author: author.name.name, avatar: author.avatar.src, id: entry.id.id, link: readPostUrl, published: entry.published.published, thumbnail: entry.thumbnail?.url, title: entry.title.title)
                }
            }
            entry.isSave?.toggle()
        } label: {
            Image(systemName: entry.isSave == true ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
        }
        .buttonStyle(.plain)
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
