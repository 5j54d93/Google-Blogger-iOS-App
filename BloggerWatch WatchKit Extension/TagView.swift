//
//  TagView.swift
//  BloggerWatch WatchKit Extension
//
//  Created by 莊智凱 on 2022/1/13.
//

import SwiftUI
import CoreData

struct TagView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.timestamp, ascending: true)], animation: .default) private var tags: FetchedResults<Tag>
    
    @State private var showAddTagSheet = false
    @State private var selectTag: String?
    @State private var inputTag = ""
    
    var body: some View {
        NavigationView {
            List {
                ZStack {
                    HStack {
                        Button {
                            selectTag = "posts"
                        } label: {
                            Label("Posts", systemImage: "doc.richtext")
                        }
                        .frame(maxWidth: .infinity)
                        Divider().padding(.vertical)
                        Button {
                            selectTag = "pages"
                        } label: {
                            Label("Pages", systemImage: "doc.plaintext")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(tag: "posts", selection: $selectTag) {
                        ListView(selectTag: "posts")
                    } label: {
                        EmptyView()
                    }
                    .hidden()
                    
                    NavigationLink(tag: "pages", selection: $selectTag) {
                        ListView(selectTag: "pages")
                    } label: {
                        EmptyView()
                    }
                    .hidden()
                }
                .listRowBackground(
                    Rectangle()
                        .foregroundColor(.orange)
                        .cornerRadius(10)
                )
                Section(header: Label("Tags", systemImage: "line.3.horizontal.decrease.circle"), footer: Text("Slide from right to left to delete tag.")) {
                    Button {
                        showAddTagSheet = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Add a tag...", systemImage: "plus")
                            Spacer()
                        }
                    }
                    ForEach(tags) { tag in
                        NavigationLink {
                            ListView(selectTag: tag.tag!)
                        } label: {
                            HStack {
                                Spacer()
                                Text(tag.tag!)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteTag)
                }
            }
            .navigationBarTitle("Blogger")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showAddTagSheet) {
            VStack {
                TextField("Add a tag...", text: $inputTag)
                    .onSubmit { if inputTag != "" { addTag(tag: inputTag) } }
                Button {
                    showAddTagSheet = false
                } label: {
                    Text("Done")
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .buttonStyle(BorderedButtonStyle(tint: .orange.opacity(255)))
            }
        }
    }
    
    private func addTag(tag: String) {
        withAnimation {
            let newTag = Tag(context: viewContext)
            newTag.timestamp = Date()
            newTag.tag = tag

            do {
                try viewContext.save()
            } catch {
            }
        }
    }
    
    private func deleteTag(offsets: IndexSet) {
        withAnimation {
            offsets.map { tags[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
            }
        }
    }
}
