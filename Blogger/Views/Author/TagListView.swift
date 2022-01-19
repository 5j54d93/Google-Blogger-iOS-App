//
//  TagListView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/18.
//

import SwiftUI
import CoreData

struct TagListView: View {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.timestamp, ascending: true)], animation: .default) private var tags: FetchedResults<Tag>
    
    @State private var showNonInputTagAlert = false
    @State private var showAddTagButtomSheet = false
    @State private var showAlreadyHaveTagAlert = false
    
    var body: some View {
        Group {
            if tags.isEmpty {
                Group {
                    Text("You don't have saved any interest.").bold().font(.title3)
                        .multilineTextAlignment(.center)
                    ( Text("Tap the ") + Text(Image(systemName: "plus")) + Text(" to add your favorite tag here.") )
                        .multilineTextAlignment(.center)
                    Button {
                        showAddTagButtomSheet = true
                    } label: {
                        Text("Add a tag")
                            .padding(.vertical)
                            .padding(.horizontal, 100)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
            } else {
                List {
                    ForEach(tags) { tag in
                        Text(tag.tag!)
                    }
                    .onDelete(perform: deleteTag)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            showAddTagButtomSheet = true
                        } label: {
                            Label("Add Tag", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .navigationTitle("Customize your interests")
        .navigationBarTitleDisplayMode(.inline)
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
