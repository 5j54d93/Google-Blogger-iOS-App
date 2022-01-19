//
//  SavedEntryRowView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct SavedEntryRowView: View {
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var readPost = false
    @State private var postUrl = ""
    @State private var showUnsaveAlert = false
    
    //for edit note data
    @Binding var author: String
    @Binding var avatar: String
    @Binding var title: String
    @Binding var published: Date
    @Binding var thumbnail: String
    @Binding var note: String
    
    @Binding var editNote: Bool
    @Binding var editMode: EditMode
    
    var savedPost: SavedPost
    
    var body: some View {
        Button {
            readPost = true
            postUrl = savedPost.link!
        } label: {
            VStack(alignment: .leading) {
                if !editMode.isEditing {
                    Button {
                        editNote = true
                        author = savedPost.author!
                        avatar = savedPost.avatar!
                        title = savedPost.title!
                        published = savedPost.published!
                        thumbnail = savedPost.thumbnail!
                        note = savedPost.note!
                    } label: {
                        HStack {
                            Rectangle().frame(width: 6, height: 25)
                            if let note = savedPost.note {
                                Text(note).foregroundColor(.gray)
                            }
                        }
                    }
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
                        if let author = savedPost.author {
                            Text(author)
                        }
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        if let title = savedPost.title {
                            Text(title).bold().font(.title3)
                        }
                        if !editMode.isEditing {
                            HStack {
                                if let published = savedPost.published {
                                    Text(published, format: .dateTime.year().month().day())
                                }
                                Spacer()
                                Button {
                                    showUnsaveAlert = true
                                } label: {
                                    Text(Image(systemName: "bookmark.fill"))
                                }
                                Menu {
                                    Button {
                                        readPost = true
                                        postUrl = savedPost.link!
                                    } label: {
                                        Label("Read", systemImage: "doc.richtext")
                                    }
                                    .buttonStyle(.plain)
                                    Button(role: .destructive) {
                                        showUnsaveAlert = true
                                    } label: {
                                        Label("Unsave", systemImage: "bookmark.slash")
                                    }
                                } label: {
                                    Text(Image(systemName: "ellipsis"))
                                }
                            }
                            .padding(.top, 2)
                            .foregroundColor(.gray)
                        }
                    }
                    if let thumbnail = savedPost.thumbnail {
                        let resVarId = thumbnail.lastIndex(of: "s") ?? thumbnail.endIndex
                        let fullResUrl = thumbnail[..<resVarId]
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
        }
        .fullScreenCover(isPresented: $readPost) {
            SavedPostView(readPost: $readPost, postUrl: $postUrl, savedPost: savedPost)
        }
        .contextMenu {
            Button {
                readPost = true
                postUrl = savedPost.link!
            } label: {
                Label("Read", systemImage: "doc.richtext")
            }
            Button(role: .destructive) {
                showUnsaveAlert = true
            } label: {
                Label("Unsave", systemImage: "bookmark.slash")
            }
        }
        .onDisappear {
            editMode = .inactive
        }
        .alert(isPresented: $showUnsaveAlert) {
            Alert(
                title: Text("Are you sure to unsave this post?"),
                message: Text(savedPost.title!),
                primaryButton: .default(
                    Text("Yes"),
                    action: { deletePost(id: savedPost.id!) }
                ),
                secondaryButton: .destructive(
                    Text("Cancel"),
                    action: { showUnsaveAlert = false }
                )
            )
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
