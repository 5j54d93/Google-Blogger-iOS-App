//
//  SettingView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/12.
//

import SwiftUI
import CoreData

struct SettingView: View {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("blogURL") var blogURL: String = "https://sharing-life-in-tw.blogspot.com"
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @FocusState private var isFocused: Bool
    
    @State private var showAuthorModeBottomSheet = false
    @State private var inputURL = ""
    @State private var showSafari = false
    @State private var SafariUrl = ""
    
    @Binding var showSetting: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings").bold().font(.title3).frame(maxWidth: .infinity)
                    .overlay(
                        Button {
                            showSetting = false
                        } label: {
                            Text(Image(systemName: "chevron.backward")).bold().font(.title3).padding(.leading)
                        }
                        , alignment: .leading
                    )
                
                List {
                    Button("Support us") {
                        SafariUrl = "https://sharing-life-in-tw.blogspot.com/p/support-us.html"
                        showSafari = true
                    }
                    Section(header: Text("Configure Blogger")) {
                        NavigationLink {
                            TagListView().environment(\.managedObjectContext, persistenceController.container.viewContext)
                        } label: {
                            Text("Customize your interests")
                        }
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
                    }
                    
                    Section(header: Text("Social")) {
                        Button("Follow us") {
                            SafariUrl = "https://linktr.ee/5j_54d93"
                            showSafari = true
                        }
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        HStack {
                            Label(
                                title: { Text("Twitter") },
                                icon: {
                                    Image("Twitter")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            )
                            Spacer()
                            Button("view") {
                                SafariUrl = "https://twitter.com/5j_54d93"
                                showSafari = true
                            }
                        }
                        HStack {
                            Label(
                                title: { Text("Facebook") },
                                icon: {
                                    Image("Facebook")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            )
                            Spacer()
                            Button("view") {
                                SafariUrl = "https://www.facebook.com/5j54d93"
                                showSafari = true
                            }
                        }
                    }
                    
                    Section(header: Text("About Blogger")) {
                        Button("Privacy policy") {
                            SafariUrl = "https://sharing-life-in-tw.blogspot.com/p/privacy-policy.html"
                            showSafari = true
                        }
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    
                    Section(header: Text("Version 1.0.0")) {
                        if blogURL != "https://sharing-life-in-tw.blogspot.com" {
                            Button("Author Mode") {
                                showAuthorModeBottomSheet = true
                            }
                        }
                    }
                    .onTapGesture(count: 5) {
                        showAuthorModeBottomSheet = true
                    }
                }
                .listStyle(.grouped)
            }
            .preferredColorScheme(preferColorScheme == "System" ? colorScheme : preferColorScheme == "Dark" ? .dark : .light)
            .bottomSheet(isPresented: $showAuthorModeBottomSheet) {
                VStack {
                    HStack {
                        Text("Input your blog URL").bold().frame(maxWidth: .infinity)
                            .overlay {
                                HStack {
                                    Button {
                                        showAuthorModeBottomSheet = false
                                    } label: {
                                        Text(Image(systemName: "xmark")).bold()
                                    }
                                    Spacer()
                                }
                            }
                    }.font(.title3)
                    Spacer()
                    Text("Your blog URL should have prefix 'https://' and postfix 'blogspot.com' or provided by Google.")
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true).padding()
                    TextField("Input your blog URL...", text: $inputURL)
                        .padding(7)
                        .background(colorScheme == .light ? Color(red: 0.949, green: 0.949, blue: 0.949) : Color(red: 41/255, green: 41/255, blue: 41/255))
                        .cornerRadius(8)
                        .padding()
                        .focused($isFocused)
                        .onSubmit { if inputURL != "" { blogURL = inputURL } }
                        .onAppear {
                            inputURL = "https://developers.googleblog.com"
                        }
                    HStack {
                        Button {
                            if inputURL != "" { blogURL = inputURL }
                            showAuthorModeBottomSheet = false
                            showSetting = false
                        } label: {
                            Text("Done")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        .padding()
                        Button {
                            blogURL = "https://sharing-life-in-tw.blogspot.com"
                            showAuthorModeBottomSheet = false
                        } label: {
                            Text("Reset")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        .padding()
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showSafari) {
            SafariView(url: $SafariUrl)
        }
    }
}
