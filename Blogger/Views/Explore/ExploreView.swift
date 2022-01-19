//
//  ExploreView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI

struct ExploreView: View {
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var bloggerSearchFeedViewModel = BloggerSearchFeedViewModel()
    
    @FocusState private var isFocused: Bool
    
    @State private var searchText = ""
    
    @Binding var backToTop: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Explore").bold().font(.largeTitle)
                    .onTapGesture {
                        backToTop.toggle()
                    }
                Spacer()
            }
            .padding([.bottom, .horizontal])
            
            HStack {
                TextField("Search Blogger", text: $searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(colorScheme == .light ? Color(red: 0.949, green: 0.949, blue: 0.949) : Color(red: 41/255, green: 41/255, blue: 41/255))
                    .cornerRadius(8)
                    .onSubmit(of: .search) {
                        bloggerSearchFeedViewModel.fetchSearchFeed(term: searchText)
                    }
                    .onChange(of: searchText) { _ in
                        bloggerSearchFeedViewModel.fetchSearchFeed(term: searchText)
                    }
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(colorScheme == .light ? .gray : .white)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            if searchText != "" {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(colorScheme == .light ? .gray : .white)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .focused($isFocused)
                
                if isFocused {
                    Button("Cancel") {
                        isFocused = false
                        searchText = ""
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                }
            }
            .padding([.horizontal, .bottom])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let feed = bloggerSearchFeedViewModel.feed {
                        if let categories = feed.category {
                            ForEach(categories, id: \.term) { category in
                                Button {
                                    searchText = category.term
                                } label: {
                                    Text(category.term)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 20)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .background(colorScheme == .light ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color(red: 41/255, green: 41/255, blue: 41/255))
                                        .clipShape(Capsule())
                                }
                                .padding(category.term == categories.first?.term ? [.leading, .bottom] : category.term == categories.last?.term ? [.trailing, .bottom] : .bottom)
                            }
                        }
                    }
                }
            }
            
            ScrollViewReader { scrollView in
                if searchText == "" {
                    Divider()
                    if bloggerSearchFeedViewModel.feed == nil {
                        Group {
                            Text("You're offline").bold().font(.title3).padding(.top)
                            Text("Make sure you're connected to the internet and try again.")
                                .multilineTextAlignment(.center).padding(.vertical).foregroundColor(.gray)
                            Button {
                                bloggerSearchFeedViewModel.fetchSearchFeed(term: "")
                            } label: {
                                Text("Try again")
                                    .padding(.vertical)
                                    .padding(.horizontal, 70)
                                    .foregroundColor(.accentColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.accentColor)
                                    )
                            }
                        }
                        .padding(.horizontal, 30)
                        Spacer()
                    } else {
                        List {
                            ( Text(Image(systemName: "sun.haze")) + Text(" RECOMMENDED FOR YOU") )
                                .bold().listRowSeparator(.hidden).id(0)
                                .onChange(of: backToTop) { _ in
                                    scrollView.scrollTo(0)
                                }
                            if let feeds = bloggerSearchFeedViewModel.feed {
                                ForEach(feeds.entry, id: \.id.id) { entry in
                                    ExploreEntryRowView(entry: entry)
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .refreshable {
                            bloggerSearchFeedViewModel.fetchSearchFeed(term: "")
                        }
                        .listStyle(.inset)
                    }
                } else {
                    List {
                        EmptyView().id(0)
                            .onChange(of: backToTop) { _ in
                                scrollView.scrollTo(0)
                            }
                        if let feeds = bloggerSearchFeedViewModel.feed {
                            ForEach(feeds.entry, id: \.id.id) { entry in
                                EntryRowView(entry: entry)
                            }
                        }
                    }
                    .listStyle(.inset)
                }
            }
        }
    }
}
