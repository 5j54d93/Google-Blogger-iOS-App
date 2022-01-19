//
//  BloggerFeedViewModel.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import Foundation
import SwiftUI

@MainActor
class BloggerFeedViewModel: ObservableObject {
    
    @AppStorage("blogURL") var blogURL: String = "https://sharing-life-in-tw.blogspot.com"
    
    @Published var feed: Feed?
    
    init() {
        fetchFeed(term: "posts", maxResults: 10)
    }
    
    func fetchFeed(term: String, maxResults: Int) {
        let urlStr = "\(blogURL)/feeds/\(term)/default?alt=json&start-index=1&max-results=\(maxResults)"
        if let url = URL(string: urlStr) {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //2021-11-03T22:55:00.031+08:00
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let bolggerFeedResponse = try decoder.decode(BloggerFeedJSONModel.self, from: data)
                    feed = bolggerFeedResponse.feed
                } catch {
                }
            }
        }
    }
}
