//
//  ListView.swift
//  BloggerWatch WatchKit Extension
//
//  Created by 莊智凱 on 2022/1/11.
//

import SwiftUI

struct ListView: View {
    
    @StateObject var bloggerFeedViewModel = BloggerFeedViewModel()
    @StateObject var bloggerSearchFeedViewModel = BloggerSearchFeedViewModel()
    
    @State private var showTagDelete = false
    @State private var maxResults = 10
    
    var selectTag: String
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
            List {
                if selectTag == "posts" || selectTag == "pages" {
                    if let entry = bloggerFeedViewModel.feed?.entry {
                        ForEach(entry, id: \.id.id) { entry in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(entry.title.title).lineLimit(2)
                                    Text(entry.published.published, format: .dateTime.year().month().day()).font(.caption).foregroundColor(.gray)
                                }
                                if let thumbnail = entry.thumbnail {
                                    let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
                                    let fullResUrl = thumbnail.url[..<resVarId]
                                    Spacer()
                                    AsyncImage(url: URL(string: fullResUrl + "s720")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.overlay {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: geo.size.width/4, height: geo.size.width/4)
                                    .clipped()
                                }
                            }
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
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(entry.title.title).lineLimit(2)
                                    Text(entry.published.published, format: .dateTime.year().month().day()).font(.caption).foregroundColor(.gray)
                                }
                                if let thumbnail = entry.thumbnail {
                                    let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
                                    let fullResUrl = thumbnail.url[..<resVarId]
                                    Spacer()
                                    AsyncImage(url: URL(string: fullResUrl + "s480")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.overlay {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: geo.size.width/4, height: geo.size.width/4)
                                    .clipped()
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(selectTag)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if selectTag == "posts" || selectTag == "pages" {
                    bloggerFeedViewModel.fetchFeed(term: selectTag, maxResults: maxResults)
                } else {
                    bloggerSearchFeedViewModel.fetchSearchFeed(term: selectTag)
                }
            }
        }
        }
    }
}
