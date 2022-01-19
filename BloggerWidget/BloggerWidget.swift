//
//  BloggerWidget.swift
//  BloggerWidget
//
//  Created by 莊智凱 on 2022/1/9.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), entry: Array(repeating: Entries(isSave: nil, id: Entries.Id(id: ""), published: Entries.Published(published: Date()), category: nil, title: Entries.Title(title: ""), content: Entries.Content(content: ""), link: Array(repeating: Links(rel: "", href: ""), count: 4), author: Array(repeating: Author(name: Author.Name(name: ""), avatar: Author.Avatar(src: "")), count: 1), thumbnail: nil, commentNum: nil), count: 4), uiImage: Array(repeating: UIImage(), count: 4))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        fetchPosts { entries in
            var uiImages: [UIImage] = Array(repeating: UIImage(), count: 4)
            let currentDate = Date()
            var count = 0
            for index in 0..<entries.count {
                if let thumbnail = entries[index].thumbnail {
                    let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
                    let fullResUrl = thumbnail.url[..<resVarId]
                    URLSession.shared.dataTask(with: URL(string: fullResUrl + "s480")!) { data, response, error in
                        if let data = data, let uiImage = UIImage(data: data) {
                            uiImages[index] = uiImage
                            count += 1
                            if count == entries.count - 1 {
                                let entry = Entry(date: currentDate, entry: entries, uiImage: uiImages)
                                completion(entry)
                            }
                        }
                    }.resume()
                } else {
                    count += 1
                    if count == entries.count - 1 {
                        let entry = Entry(date: currentDate, entry: entries, uiImage: uiImages)
                        completion(entry)
                    }
                }
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchPosts { entries in
            var uiImages: [UIImage] = Array(repeating: UIImage(), count: 4)
            let currentDate = Date()
            var count = 0
            for index in 0..<entries.count {
                if let thumbnail = entries[index].thumbnail {
                    let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
                    let fullResUrl = thumbnail.url[..<resVarId]
                    URLSession.shared.dataTask(with: URL(string: fullResUrl + "s480")!) { data, response, error in
                        if let data = data, let uiImage = UIImage(data: data) {
                            uiImages[index] = uiImage
                            count += 1
                            if count == entries.count {
                                let entry = Entry(date: currentDate, entry: entries, uiImage: uiImages)
                                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)
                                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
                                completion(timeline)
                            }
                        }
                    }.resume()
                } else {
                    count += 1
                    if count == entries.count {
                        let entry = Entry(date: currentDate, entry: entries, uiImage: uiImages)
                        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)
                        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
                        completion(timeline)
                    }
                }
            }
        }
    }
}

struct BloggerWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var data: Entry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            GeometryReader { geo in
                ZStack {
                    Image(uiImage: data.uiImage[0])
                        .resizable()
                        .scaledToFill()
                    VStack {
                        Spacer()
                        Text(data.entry[0].title.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .padding(10)
                            .padding(.trailing, 5)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .center))
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        case .systemMedium:
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 8) {
                    Label {
                        Text("Latest posts").bold().font(.subheadline)
                    } icon: {
                        Text(Image(systemName: "doc.richtext")).bold().font(.subheadline).foregroundColor(.orange)
                    }
                    ForEach(0..<2) { index in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(data.entry[index].published.published, format: .dateTime.year().month().day()).bold().foregroundColor(.gray).font(.caption)
                                Text(data.entry[index].title.title).bold().font(.caption)
                            }
                            Spacer()
                            Image(uiImage: data.uiImage[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.height/3.2, height: geo.size.height/3.2)
                                .cornerRadius(5)
                                .clipped()
                        }
                    }
                }.padding().frame(width: geo.size.width, height: geo.size.height)
            }
        case .systemLarge:
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text("Latest posts").bold().font(.subheadline)
                    } icon: {
                        Text(Image(systemName: "doc.richtext")).bold().font(.subheadline).foregroundColor(.orange)
                    }
                    ForEach(0..<4) { index in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(data.entry[index].published.published, format: .dateTime.year().month().day()).bold().foregroundColor(.gray).font(.caption)
                                Text(data.entry[index].title.title).bold().font(.caption)
                            }
                            Spacer()
                            Image(uiImage: data.uiImage[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.height/5.3, height: geo.size.height/5.3)
                                .cornerRadius(5)
                                .clipped()
                        }
                    }
                }.padding().frame(width: geo.size.width, height: geo.size.height)
            }
        case .systemExtraLarge:
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text("Latest posts on Blogger").bold().font(.subheadline)
                    } icon: {
                        Text(Image(systemName: "doc.richtext")).bold().font(.subheadline).foregroundColor(.orange)
                    }
                    ForEach(0..<4) { index in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(data.entry[index].title.title).bold().font(.caption)
                                Spacer()
                                HStack {
                                    ForEach(data.entry[index].category!, id: \.term) { category in
                                        Text("-" + category.term).bold().foregroundColor(.gray).font(.caption)
                                    }
                                }
                                Spacer()
                                ( Text(Image(systemName: "calendar")) + Text(" ") + Text(data.entry[index].published.published, format: .dateTime.year().month().day()) + Text(" ") + Text(Image(systemName: "text.bubble")) + Text(" ")  + Text("\(data.entry[index].commentNum!.commentNum) comment")).bold().foregroundColor(.gray).font(.caption)
                            }
                            Spacer()
                            Image(uiImage: data.uiImage[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.height/5.3, height: geo.size.height/5.3)
                                .cornerRadius(5)
                                .clipped()
                        }
                    }
                }.padding().frame(width: geo.size.width, height: geo.size.height)
            }
        default: Text("")
        }
    }
}

@main
struct BloggerWidget: Widget {
    let kind: String = "BloggerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BloggerWidgetEntryView(data: entry)
        }
        .configurationDisplayName("Blogger Widget")
        .description("Add this widget on your iPhone to view lastest posts!")
    }
}
