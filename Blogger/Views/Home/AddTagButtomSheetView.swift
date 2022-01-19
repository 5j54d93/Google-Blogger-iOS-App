//
//  AddTagButtomSheetView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/19.
//

import SwiftUI

struct AddTagButtomSheetView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Tag.timestamp, ascending: true)], animation: .default) private var tags: FetchedResults<Tag>
    
    @FocusState private var isFocused: Bool
    
    @State private var inputTag = ""
    @State private var inCoreData = false
    
    @Binding var showAddTagButtomSheet: Bool
    @Binding var showNonInputTagAlert: Bool
    @Binding var showAlreadyHaveTagAlert: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Customize your interests").bold().frame(maxWidth: .infinity)
                    .overlay {
                        HStack {
                            Button {
                                showAddTagButtomSheet = false
                            } label: {
                                Text(Image(systemName: "xmark")).bold()
                            }
                            Spacer()
                        }
                    }
            }.font(.title3)
            Spacer()
            Text("Input a word you want to add as a tag on tap of Home").multilineTextAlignment(.center)
            TextField("Input a tag...", text: $inputTag)
                .padding(7)
                .background(colorScheme == .light ? Color(red: 0.949, green: 0.949, blue: 0.949) : Color(red: 41/255, green: 41/255, blue: 41/255))
                .cornerRadius(8)
                .padding()
                .focused($isFocused)
                .onSubmit(of: .search) {
                    if inputTag != "" {
                        inCoreData = false
                        tags.forEach { tag in
                            if tag.tag! == inputTag {
                                inCoreData = true
                            }
                        }
                        if inCoreData == true {
                            showAlreadyHaveTagAlert = true
                        } else {
                            addTag(tag: inputTag)
                        }
                    }
                }
            Button {
                if inputTag != "" {
                    inCoreData = false
                    tags.forEach { tag in
                        if tag.tag! == inputTag {
                            inCoreData = true
                        }
                    }
                    if inCoreData == true {
                        showAlreadyHaveTagAlert = true
                    } else { addTag(tag: inputTag) }
                } else { showNonInputTagAlert = true }
                showAddTagButtomSheet = false
            } label: {
                Text("Done")
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
            .padding()
            Spacer()
        }
        .padding()
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
}
