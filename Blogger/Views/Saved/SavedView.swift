//
//  SavedView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData

struct SavedView: View {
    
    let persistenceController = PersistenceController.shared
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @State private var editMode: EditMode = .inactive
    @State private var editNote = false
    
    //for edit note data
    @State private var author = ""
    @State private var avatar = ""
    @State private var title = ""
    @State private var published = Date()
    @State private var thumbnail = ""
    @State private var note = ""
    
    @Binding var backToTop: Bool
    @Binding var selectTab: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Saved").bold().font(.largeTitle).padding(.leading)
                .onTapGesture {
                    backToTop.toggle()
                }
            HStack {
                ( Text("Saved: ") + Text(String(SavedPosts.count) + " ") + Text(SavedPosts.count > 1 ? "stories" : "stroy") ).font(.title3)
                Spacer()
                if !SavedPosts.isEmpty {
                    Text(editMode.isEditing ? "Done" : "Edit")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            switch editMode {
                            case .active: editMode = .inactive
                            case .inactive: editMode = .active
                            default: break
                            }
                        }
                }
            }
            .padding(.top, 1)
            .padding(.horizontal)
            
            ScrollViewReader { scrollView in
                if SavedPosts.isEmpty {
                    Divider().id(0)
                    Group {
                        Text("You don't have saved any content.").bold().font(.title3)
                            .multilineTextAlignment(.center)
                        ( Text("Tap the ") + Text(Image(systemName: "bookmark")) + Text(" to add your favorite stories and books to here.") )
                            .multilineTextAlignment(.center)
                        Button {
                            selectTab = 1
                        } label: {
                            Text("Start browsing")
                                .padding(.vertical)
                                .padding(.horizontal, 70)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                }
                List {
                    EmptyView().id(0)
                        .onChange(of: backToTop) { _ in
                            scrollView.scrollTo(0)
                            backToTop = false
                        }
                    ForEach(SavedPosts) { SavedPost in
                        SavedEntryRowView(author: $author, avatar: $avatar, title: $title, published: $published, thumbnail: $thumbnail, note: $note, editNote: $editNote, editMode: $editMode, savedPost: SavedPost)
                            .sheet(isPresented: $editNote) {
                                EditNoteView(editNote: $editNote, author: $author, avatar: $avatar, title: $title, published: $published, thumbnail: $thumbnail, note: $note, savedPost: SavedPost)
                            }
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    }
                    .onDelete(perform: deletePost)
                }
                .listStyle(.inset)
                .toolbar{ EditButton() }
                .environment(\.editMode, $editMode)
            }
        }
    }
    
    private func deletePost(offsets: IndexSet) {
        withAnimation {
            offsets.map { SavedPosts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
            }
        }
    }

}
