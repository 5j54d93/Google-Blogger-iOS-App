# Google Blogger iOS App

[![Swift](https://github.com/5j54d93/Google-Blogger-iOS-App/actions/workflows/swift.yml/badge.svg)](https://github.com/5j54d93/Google-Blogger-iOS-App/actions/workflows/swift.yml)
[![GitHub license](https://img.shields.io/github/license/5j54d93/My-Favorite-NETFLIX)](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/LICENSE)
![GitHub Repo stars](https://img.shields.io/github/stars/5j54d93/Google-Blogger-iOS-App)
![GitHub repo size](https://img.shields.io/github/repo-size/5j54d93/Google-Blogger-iOS-App)
![Platform](https://img.shields.io/badge/platform-iOS｜iPadOS｜watchOS｜macOS-lightgrey)

List posts with infinite scroll from [**Google Blogger API**](https://developers.google.com/blogger/docs/3.0/using?hl=en) in MVVM architecture, and using [**SwiftUI**](https://developer.apple.com/xcode/swiftui/) to design like [**Medium iOS App**](https://apps.apple.com/tw/app/medium/id828256236), which could read, search, save, comment posts, and so many excellent features！

> **iOS**：iPhone 13 Pro Max

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Home-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Explore-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Saved-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Author-Demo.gif" width='25%' height='100%'/>

> **Widgets**：iPad Pro（12.9-inch、5th generation）

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/widgets.jpg" width='100%' height='100%'/>

> **watchOS**：Apple Watch Series 7 - 45mm

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-1.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-2.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-3.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-4.png" width='25%' height='100%'/>

## Features

### [HomeView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeView.swift)

- Show「You're offline」if we can't fetch data from API
- `.scrollTo()` top when user click on `TabView`'s `tabItem`
- when there's more posts to load, show `ProgressView()` at list bottom with `.onAppear` to achieve infinite scroll
- use `.refreshable` to let list could refresh when been pull down

### [HomeTagView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeTagView.swift)

- show tags that store in `Core Data`
- `.onLongPressGesture` tag could show delete icon aside which on click could delet tag form `Core Data`

### [EntryRowView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeTagView.swift)

- use `.prefix(3)` to only show the first 3 items in array with `ForEach`
- deal with post's thumbnail url to get higher resolution image

```swift
let resVarId = thumbnail.url.lastIndex(of: "s") ?? thumbnail.url.endIndex
let fullResUrl = thumbnail.url[..<resVarId]
AsyncImage(url: URL(string: fullResUrl + "s480")) { image in
    image
        .resizable()
        .scaledToFill()
} placeholder: {
    Color.gray.overlay { ProgressView() }
}
.frame(width: 75, height: 75)
.clipped()
```

### [SettingView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Author/SettingView.swift)

- if user click on version tag 5 times could change Blogger url in API to change this app's content！

### [Widget](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/BloggerWidget/BloggerWidget.swift)

- 4 different size
- UI design like [Apple News](https://www.apple.com/apple-news/)
- data fetch from API to get the newest posts
- we also call API on `getSnapshot` in addition to `getTimeline`

### [Watch](https://github.com/5j54d93/Google-Blogger-iOS-App/tree/main/BloggerWatch%20WatchKit%20Extension)

- UI design with SwiftUI
- data fetch from API
- two clickable `Button` in a row of `List`

## License：MIT

This package is [MIT licensed](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/LICENSE).
