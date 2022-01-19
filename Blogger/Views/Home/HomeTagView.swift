//
//  HomeTagView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI
import CoreData
import BottomSheet

struct HomeTagView: View {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.timestamp, ascending: true)], animation: .default) private var tags: FetchedResults<Tag>
    
    @State private var showNonInputTagAlert = false
    @State private var showAlreadyHaveTagAlert = false
    
    @Binding var showTagDelete: Bool
    @Binding var selectTag: String
    @Binding var showAddTagButtomSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    showAddTagButtomSheet = true
                } label: {
                    Text(Image(systemName: "plus"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .background(colorScheme == .light ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
                        .clipShape(Capsule())
                }
                .padding(.leading)
                Button {
                    selectTag = "posts"
                    showTagDelete = false
                } label: {
                    Text("Post")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .foregroundColor(selectTag == "posts" ? colorScheme == .light ? .white : .black : colorScheme == .light ? .black : .white)
                        .background(selectTag == "posts" ? colorScheme == .light ? .black : Color(red: 242/255, green: 242/255, blue: 242/255) : colorScheme == .light ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
                        .clipShape(Capsule())
                }
                Button {
                    selectTag = "pages"
                    showTagDelete = false
                } label: {
                    Text("Page")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .foregroundColor(selectTag == "pages" ? colorScheme == .light ? .white : .black : colorScheme == .light ? .black : .white)
                        .background(selectTag == "pages" ? colorScheme == .light ? .black : Color(red: 242/255, green: 242/255, blue: 242/255) : colorScheme == .light ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
                        .clipShape(Capsule())
                }
                ForEach(tags) { tag in
                    Group {
                        if showTagDelete {
                            HStack {
                                Text(Image(systemName: "multiply.circle"))
                                    .foregroundColor(.red)
                                    .onTapGesture { deleteTag(tag: tag.tag!) }
                                if tag.tag! != "" { Text(tag.tag!) }
                            }
                        } else { Text(tag.tag!) }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .foregroundColor(selectTag == tag.tag! ? colorScheme == .light ? .white : .black : colorScheme == .light ? .black : .white)
                    .background(selectTag == tag.tag! ? colorScheme == .light ? .black : Color(red: 242/255, green: 242/255, blue: 242/255) : colorScheme == .light ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
                    .clipShape(Capsule())
                    .padding(.trailing, tags.last == tag ? 15 : 0)
                    .onTapGesture {
                        selectTag = tag.tag!
                        showTagDelete = false
                    }
                    .onLongPressGesture { showTagDelete.toggle() }
                }
            }.foregroundColor(.black)
        }
        .bottomSheet(isPresented: $showAddTagButtomSheet) {
            AddTagButtomSheetView(showAddTagButtomSheet: $showAddTagButtomSheet, showNonInputTagAlert: $showNonInputTagAlert, showAlreadyHaveTagAlert: $showAlreadyHaveTagAlert)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .alert("You don't input a tag", isPresented: $showNonInputTagAlert) {
            Button("OK") { showNonInputTagAlert = false }
        }
        .alert("You've already added this tag before", isPresented: $showAlreadyHaveTagAlert) {
            Button("Fine") { showAlreadyHaveTagAlert = false }
        }
    }
    
    private func deleteTag(tag: String) {
        withAnimation {
            let request = Tag.fetchRequest() as NSFetchRequest<Tag>
            request.predicate = NSPredicate(format: "tag == %@", tag)
            
            do {
                let tag = try viewContext.fetch(request)
                viewContext.delete(tag[0])
                try viewContext.save()
            } catch {
            }
        }
    }
}
