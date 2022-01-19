//
//  AuthorView.swift
//  Blogger
//
//  Created by 莊智凱 on 2022/1/8.
//

import SwiftUI

struct AuthorView: View {
    
    @AppStorage("blogURL") var blogURL: String = "https://sharing-life-in-tw.blogspot.com"
    @AppStorage("preferColorScheme") var preferColorScheme: String = "System"
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var bloggerPostsFeedViewModel = BloggerFeedViewModel()
    @StateObject var bloggerPagesFeedViewModel = BloggerFeedViewModel()
    
    @State private var showMore = false
    @State private var showSetting = false
    @State private var showSheet = false
    @State private var selectAbout = "app"
    @State private var sheetUrl = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                Button {
                    showMore = true
                } label: {
                    Text(Image(systemName: "ellipsis"))
                }
                .foregroundColor(colorScheme == .light ? .black : .white)
                .actionSheet(isPresented: $showMore) {
                    ActionSheet(
                        title: Text("Version: 1.0.0"),
                        buttons: [
                            .default(
                                Text("Setting"),
                                action: { showSetting = true }
                            ),
                            .cancel()
                        ]
                    )
                }
            }
            HStack {
                if let feed = bloggerPostsFeedViewModel.feed {
                    ForEach(feed.author, id: \.name.name) { author in
                        AsyncImage(url: URL(string: author.avatar.src.hasPrefix("https:") ? author.avatar.src : "https:" + author.avatar.src)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading) {
                    if let feed = bloggerPostsFeedViewModel.feed {
                        ForEach(feed.author, id: \.name.name) { author in
                            Text(author.name.name)
                                .bold()
                                .font(.title)
                                .onAppear {
                                    bloggerPostsFeedViewModel.fetchFeed(term: "posts", maxResults: 10)
                                    bloggerPagesFeedViewModel.fetchFeed(term: "pages", maxResults: 10)
                                }
                        }
                    }
                    if let postFeed = bloggerPostsFeedViewModel.feed, let pageFeed = bloggerPagesFeedViewModel.feed {
                        if let postNum = postFeed.postNum.postNum, let pageNum = pageFeed.postNum.postNum {
                            Text(postNum + " posts・" + pageNum + " pages")
                        }
                    }
                }.padding(.leading)
                Spacer()
            }
            .padding(.vertical)
            
            HStack {
                Button {
                    showSheet = true
                    if let feed = bloggerPostsFeedViewModel.feed {
                        feed.link.forEach { link in
                            if link.rel == "alternate" {
                                sheetUrl = link.href
                            }
                        }
                    }
                } label: {
                    Text("View Blog")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(colorScheme == .light ? .black : Color(red: 41/255, green: 41/255, blue: 41/255))
                        .clipShape(Capsule())
                }
                Button {
                    showSheet = true
                    sheetUrl = "https://medium.com/@5j54d93"
                } label: {
                    Text("View Medium")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(colorScheme == .light ? .black : .white, lineWidth: 1)
                        )
                }
            }
            
            HStack {
                Text("App")
                    .padding(.bottom, 10)
                    .foregroundColor(selectAbout == "app" ? colorScheme == .light ? .black : .white : .gray)
                    .border(width: selectAbout == "app" ? 1 : 0, edges: [.bottom], color: colorScheme == .light ? .black : .white)
                    .onTapGesture {
                        selectAbout = "app"
                    }
                Text("App Creator")
                    .padding(.bottom, 10)
                    .foregroundColor(selectAbout == "author" ? colorScheme == .light ? .black : .white : .gray)
                    .border(width: selectAbout == "author" ? 1 : 0, edges: [.bottom], color: colorScheme == .light ? .black : .white)
                    .padding(.leading)
                    .onTapGesture {
                        selectAbout = "author"
                    }
                Spacer()
            }
            .padding(.top)
            Divider().offset(y: -8).padding(.bottom, 10)
            
            if selectAbout == "app" {
                VStack {
                    Text("Hope you enjoy reading on Blogger.").bold().font(.title3).padding(.vertical)
                    ( Text("And we also have ") + Text(Image(systemName: "rectangle.3.group")) + Text(" widget and ") + Text(Image(systemName: "applewatch")) + Text(" Apple Watch app, welcome to explore it～") )
                        .multilineTextAlignment(.center).padding(.horizontal, 30).padding(.bottom, 30)
                }
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 229/255, green: 229/255, blue: 229/255), lineWidth: 1))
                if blogURL != "https://sharing-life-in-tw.blogspot.com" {
                    Button {
                        blogURL = "https://sharing-life-in-tw.blogspot.com"
                        bloggerPostsFeedViewModel.fetchFeed(term: "posts", maxResults: 10)
                    } label: {
                        Text("Reset to origin Blog")
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                    .padding()
                }
            } else {
                Button {
                    showSheet = true
                    sheetUrl = "https://linktr.ee/5j_54d93"
                } label: {
                    Text("About app creator")
                        .padding(.vertical)
                        .padding(.horizontal, 70)
                        .foregroundColor(.accentColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.accentColor)
                        )
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showSetting) {
            SettingView(showSetting: $showSetting)
        }
        .sheet(isPresented: $showSheet) {
            BrowserView(url: $sheetUrl)
        }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
