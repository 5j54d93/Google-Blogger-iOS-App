//
//  EditNoteView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/9.
//

import SwiftUI
import CoreData

struct EditNoteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavedPost.timestamp, ascending: true)], animation: .default) private var SavedPosts: FetchedResults<SavedPost>
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var inputNote = ""
    
    @Binding var editNote: Bool
    @Binding var author: String
    @Binding var avatar: String
    @Binding var title: String
    @Binding var published: Date
    @Binding var thumbnail: String
    @Binding var note: String
    
    var savedPost: SavedPost
    
    var body: some View {
        VStack {
            Text("Add note").bold().font(.title3)
                .frame(maxWidth: .infinity)
                .overlay(
                    Text("Cancel")
                        .onTapGesture {
                            editNote = false
                        }
                    , alignment: .trailing
                )
            Divider()
            
            HStack {
                Rectangle().frame(width: 6, height: 25)
                TextField(note == "Add a note..." ? "Add a brief description" : note, text: $inputNote)
                    .onAppear {
                        if note != "Add a note..." {
                            inputNote = note
                        }
                    }
                    .onSubmit {
                        if inputNote == "" {
                            modifyNote(title: title, note: "Add a note...")
                        } else {
                            modifyNote(title: title, note: inputNote)
                        }
                        editNote = false
                    }
            }.padding([.vertical, .top])
            
            VStack {
                HStack {
                    AsyncImage(url: URL(string: "https:" + avatar)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray.overlay { ProgressView() }
                    }
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                    Text(author)
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(title).bold().font(.title3)
                        Text(published, format: .dateTime.year().month().day())
                            .padding(.top, 2)
                            .foregroundColor(.gray)
                    }
                    if let thumbnail = thumbnail {
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
            .padding()
            .background(colorScheme == .light ? Color(red: 250/255, green: 250/255, blue: 250/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
            .border(Color(red: 229/255, green: 229/255, blue: 229/255), width: colorScheme == .light ? 1 : 0)
            
            Button {
                if inputNote == "" {
                    modifyNote(title: title, note: "Add a note...")
                } else {
                    modifyNote(title: title, note: inputNote)
                }
                editNote = false
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .padding(.vertical)
            
            Spacer()
        }
        .padding()
    }
    
    private func modifyNote(title: String, note: String) {
        withAnimation {
            let request = SavedPost.fetchRequest() as NSFetchRequest<SavedPost>
            request.predicate = NSPredicate(format: "title == %@", title)
            
            do {
                let SavedPost = try viewContext.fetch(request)
                SavedPost[0].note = note
                try viewContext.save()
            } catch {
            }
        }
    }
}
