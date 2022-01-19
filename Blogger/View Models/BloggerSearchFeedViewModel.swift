//
//  BloggerSearchFeedViewModel.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import Foundation
import SwiftUI

@MainActor
class BloggerSearchFeedViewModel: ObservableObject {
    
    @AppStorage("blogURL") var blogURL: String = "https://sharing-life-in-tw.blogspot.com"
    
    @Published var feed: Feed?
    
    init() {
        fetchSearchFeed(term: "")
    }
    
    func fetchSearchFeed(term: String) {
        let urlStr = "\(blogURL)/feeds/posts/default?alt=json&q=\(term)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        if let url = URL(string: urlStr!) {
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
