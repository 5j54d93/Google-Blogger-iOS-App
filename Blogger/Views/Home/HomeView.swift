//
//  HomeView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var bloggerFeedViewModel = BloggerFeedViewModel()
    @StateObject var bloggerSearchFeedViewModel = BloggerSearchFeedViewModel()
    
    @State private var selectTag = "posts"
    @State private var maxResults = 10
    @State private var offline = false
    @State private var showAddTagButtomSheet = false
    @State private var showTagDelete = false
    
    @Binding var backToTop: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Home").bold().font(.largeTitle)
                    .onTapGesture {
                        backToTop.toggle()
                    }
                Spacer()
                if showAddTagButtomSheet {
                    Text(Image(systemName: "plus.circle")).font(.title)
                } else if offline {
                    Text(Image(systemName: "circle")).font(.title)
                        .overlay(
                            Text(Image(systemName: "wifi.exclamationmark")).font(.subheadline)
                        )
                        .foregroundColor(.red)
                } else {
                    if showTagDelete {
                        Button {
                            showTagDelete = false
                        } label: {
                            Text(Image(systemName: "checkmark.circle")).font(.title)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        }
                    } else {
                        Button {
                            showTagDelete = true
                        } label: {
                            Text(Image(systemName: "ellipsis.circle")).font(.title)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        }
                    }
                }
            }.padding(.horizontal)
            
            HomeTagView(showTagDelete: $showTagDelete, selectTag: $selectTag, showAddTagButtomSheet: $showAddTagButtomSheet).padding(.bottom)
            
            ScrollViewReader { scrollView in
                if selectTag == "posts" || selectTag == "pages" {
                    if bloggerFeedViewModel.feed == nil {
                        Group {
                            Text("You're offline").bold().font(.title3).padding(.top)
                            Text("Make sure you're connected to the internet and try again.")
                                .multilineTextAlignment(.center).padding(.vertical).foregroundColor(.gray)
                            Button {
                                bloggerFeedViewModel.fetchFeed(term: selectTag, maxResults: maxResults)
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
                            .onAppear { offline = true }
                            .onDisappear { offline = false }
                        }
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                } else {
                    if bloggerFeedViewModel.feed == nil {
                        Group {
                            Text("You're offline").bold().font(.title3).padding(.top)
                            Text("Make sure you're connected to the internet and try again.")
                                .multilineTextAlignment(.center).padding(.vertical).foregroundColor(.gray)
                            Button {
                                bloggerSearchFeedViewModel.fetchSearchFeed(term: selectTag)
                            } label: {
                                Text("Try again")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical)
                                    .padding(.horizontal, 30)
                                    .foregroundColor(.accentColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.accentColor)
                                    )
                            }
                            .onAppear { offline = true }
                            .onDisappear { offline = false }
                        }
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                }
                List {
                    EmptyView().id(0)
                        .onChange(of: backToTop) { _ in
                            scrollView.scrollTo(0)
                        }
                    if selectTag == "posts" || selectTag == "pages" {
                        if let entry = bloggerFeedViewModel.feed?.entry {
                            ForEach(entry, id: \.id.id) { entry in
                                EntryRowView(entry: entry)
                            }
                            if let feed = bloggerFeedViewModel.feed {
                                if maxResults <= Int(feed.postNum.postNum)! {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .onAppear {
                                            maxResults += 10
                                            bloggerFeedViewModel.fetchFeed(term: selectTag, maxResults: maxResults)
                                        }
                                }
                            }
                        }
                    } else {
                        if let entry = bloggerSearchFeedViewModel.feed?.entry {
                            ForEach(entry, id: \.id.id) { entry in
                                EntryRowView(entry: entry)
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .refreshable {
                    if selectTag == "posts" || selectTag == "pages" {
                        bloggerFeedViewModel.fetchFeed(term: selectTag, maxResults: maxResults)
                    } else {
                        bloggerSearchFeedViewModel.fetchSearchFeed(term: selectTag)
                    }
                }
            }
        }
        .onChange(of: selectTag) { _ in
            if selectTag == "posts" || selectTag == "pages" {
                bloggerFeedViewModel.fetchFeed(term: selectTag, maxResults: maxResults)
            } else {
                bloggerSearchFeedViewModel.fetchSearchFeed(term: selectTag)
            }
        }
    }
}
