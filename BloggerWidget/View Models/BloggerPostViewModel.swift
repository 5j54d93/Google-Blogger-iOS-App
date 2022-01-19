//
//  BloggerPostViewModel.swift
//  BloggerWidgetExtension
//
//  Created by 莊智凱 on 2022/1/9.
//

import Foundation

func fetchPosts(completion: @escaping ([Entries])-> ()) {
    
    let urlStr = "https://sharing-life-in-tw.blogspot.com/feeds/posts/default?alt=json&start-index=1&max-results=4"
    
    if let url = URL(string: urlStr) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" //2021-11-03T22:55:00.031+08:00
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let bolggerFeedResponse = try decoder.decode(BloggerFeedJSONModel.self, from: data)
                completion(bolggerFeedResponse.feed.entry)
            } catch {
            }
        }
    }
}
