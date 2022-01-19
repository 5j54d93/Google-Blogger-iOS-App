//
//  BloggerFeedJSONModel.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import Foundation

struct BloggerFeedJSONModel: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let category: [Category]?
    let link: [Links]
    let author: [Author]
    let postNum: PostNum
    struct PostNum: Codable {
        let postNum: String
        enum CodingKeys: String, CodingKey {
            case postNum = "$t"
        }
    }
    let entry: [Entries]
    enum CodingKeys: String, CodingKey {
        case category
        case link
        case author
        case postNum = "openSearch$totalResults"
        case entry
    }
}

struct Category: Codable {
    let term: String
}

struct Links: Codable {
    let rel: String
    let href: String
}

struct Author: Codable {
    let name: Name
    struct Name: Codable {
        let name: String
        enum CodingKeys: String, CodingKey {
            case name = "$t"
        }
    }
    let avatar: Avatar
    struct Avatar: Codable {
        let src: String
    }
    enum CodingKeys: String, CodingKey {
        case name
        case avatar = "gd$image"
    }
}

struct Entries: Codable {
    var isSave: Bool?
    
    let id: Id
    struct Id: Codable {
        let id: String
        enum CodingKeys: String, CodingKey {
            case id = "$t"
        }
    }
    let published: Published
    struct Published: Codable {
        let published: Date
        enum CodingKeys: String, CodingKey {
            case published = "$t"
        }
    }
    let category: [Category]?
    let title: Title
    struct Title: Codable {
        let title: String
        enum CodingKeys: String, CodingKey {
            case title = "$t"
        }
    }
    let content: Content
    struct Content: Codable {
        let content: String
        enum CodingKeys: String, CodingKey {
            case content = "$t"
        }
    }
    let link: [Links]
    let author: [Author]
    let thumbnail: Thumbnail?
    struct Thumbnail: Codable {
        let url: String
    }
    let commentNum: CommentNum?
    struct CommentNum: Codable {
        let commentNum: String
        enum CodingKeys: String, CodingKey {
            case commentNum = "$t"
        }
    }
    enum CodingKeys: String, CodingKey {
        case id
        case published
        case category
        case title
        case content
        case link
        case author
        case thumbnail = "media$thumbnail"
        case commentNum = "thr$total"
    }
}
