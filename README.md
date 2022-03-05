# Google Blogger iOS App

[![Swift](https://github.com/5j54d93/Google-Blogger-iOS-App/actions/workflows/swift.yml/badge.svg)](https://github.com/5j54d93/Google-Blogger-iOS-App/actions/workflows/swift.yml)
[![GitHub license](https://img.shields.io/github/license/5j54d93/My-Favorite-NETFLIX)](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/LICENSE)
![GitHub Repo stars](https://img.shields.io/github/stars/5j54d93/Google-Blogger-iOS-App)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/5j54d93/Google-Blogger-iOS-App)
![GitHub repo size](https://img.shields.io/github/repo-size/5j54d93/Google-Blogger-iOS-App)
![Platform](https://img.shields.io/badge/platform-iOS｜iPadOS｜watchOS｜macOS-lightgrey)

List posts with infinite scroll from [**Google Blogger API**](https://developers.google.com/blogger/docs/3.0/using?hl=en) in MVVM architecture, and using [**SwiftUI**](https://developer.apple.com/xcode/swiftui/) to design like [**Medium iOS App**](https://apps.apple.com/tw/app/medium/id828256236), which could read, search, save, comment posts, and so many excellent features！

> **iOS**：iPhone 13 Pro Max

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Home-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Explore-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Saved-Demo.gif" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Author-Demo.gif" width='25%' height='100%'/>

> YouTube Demo Video：[**youtu.be/xL209rnT73M**](https://youtu.be/xL209rnT73M)

## Overview

1. [**How To Use**](https://github.com/5j54d93/Google-Blogger-iOS-App#how-to-use)
2. [**Architecture Design、Features、Explanation**](https://github.com/5j54d93/Google-Blogger-iOS-App#architecture-designfeaturesexplanation)
   - [Models／BloggerFeedJSONModel](https://github.com/5j54d93/Google-Blogger-iOS-App#modelsbloggerfeedjsonmodel)
   - [ContentView](https://github.com/5j54d93/Google-Blogger-iOS-App#contentview)
   - [HomeView](https://github.com/5j54d93/Google-Blogger-iOS-App#homeview)
     - [HomeTagView](https://github.com/5j54d93/Google-Blogger-iOS-App#hometagview)
     - [AddTagButtomSheetView](https://github.com/5j54d93/Google-Blogger-iOS-App#addtagbuttomsheetview)
     - [EntryRowView](https://github.com/5j54d93/Google-Blogger-iOS-App#entryrowview)
     - [PostView](https://github.com/5j54d93/Google-Blogger-iOS-App#postview)
   - [ExploreView](https://github.com/5j54d93/Google-Blogger-iOS-App#exploreview)
   - [SavedView](https://github.com/5j54d93/Google-Blogger-iOS-App#savedview)
   - [AuthorView](https://github.com/5j54d93/Google-Blogger-iOS-App#authorview)
   - [Widget](https://github.com/5j54d93/Google-Blogger-iOS-App#widget)：iPad Pro（12.9-inch、5th generation）
   - [Watch](https://github.com/5j54d93/Google-Blogger-iOS-App#watch)：Apple Watch Series 7 - 45mm
3. [**License：MIT**](https://github.com/5j54d93/Google-Blogger-iOS-App#licensemit)

## How To Use

1. Simply click on the green「Code」button on top right
2. click「Open with Xcode」
3. Having fun to explore this Google Blogger iOS App！

if nothing happen：

- Download this repository via `git clone` or from [Releases](https://github.com/5j54d93/Google-Blogger-iOS-App/releases)

```shell
git clone https://github.com/5j54d93/Google-Blogger-iOS-App --depth
```

## Architecture Design、Features、Explanation

### [Models／BloggerFeedJSONModel](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Models/BloggerFeedJSONModel.swift)

- use `CodingKey` to change label in JSON data fetched from API

### [ContentView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/ContentView.swift)

- `TabView`：[`HomeView()`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeView.swift)、[`ExploreView()`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Explore/ExploreView.swift)、[`SavedView()`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Saved/SavedView.swift)、[`AuthorView()`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Author/AuthorView.swift)
- use `.environment(\.symbolVariants, .none)` to prevent `tabItem` with default `.fill` icon type
  - only change `tabItem` icon type to `.fill` when selected

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Home-tabItem.png" width='100%' height='100%'/>
<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Saved-tabItem.png" width='100%' height='100%'/>

### [HomeView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeView.swift)

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/HomeView.png" width='100%' height='100%'/>

- Show「You're offline」if we can't fetch data from API
- `.scrollTo()` top when user click on `TabView`'s `tabItem`
- when there's more posts to load, show `ProgressView()` at list bottom with `.onAppear` to achieve infinite scroll
- use `.refreshable` to let list could refresh when been pull down

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/You're-offline.png" width='50%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Home-ProgressView.png" width='50%' height='100%'/>

#### [HomeTagView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeTagView.swift)

- display tags with `ScrollView(.horizontal, showsIndicators: false)`
- click first plus button could triger bottomSheet（[`AddTagButtomSheetView`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/AddTagButtomSheetView.swift)）to add tag to `Core Data`
- show tags that store in `Core Data`
- `.onLongPressGesture` tag could show delete icon aside which on click could delet tag form `Core Data`

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/HomeTagView.png" width='100%' height='100%'/>

#### [AddTagButtomSheetView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/AddTagButtomSheetView.swift)

- couldn't add the same tag multiple times

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/AddTagButtomSheetView.png" width='33%' height='100%'/> <img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Add-same-tag.png" width='33%' height='100%'/>

#### [EntryRowView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/HomeTagView.swift)

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

- onClink to show `fullScreenCover` [PostView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/PostView.swift)
- long press to show `contextMenu`

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Home-contextMenu.png" width='50%' height='100%'/>

#### [PostView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Home/PostView.swift)

- use `WebKit`：[`WKWebView`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/WebKit/BrowserView.swift) to show web

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/PostView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/PostView-share.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/PostView-more.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/PostView-display-settings.png" width='25%' height='100%'/>

### [ExploreView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Explore/ExploreView.swift)

- recommended search words（posts topics）with `ScrollView(.horizontal, showsIndicators: false)` from API
- search post from API
- show recommendation posts with different UI if there's no search word

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/ExploreView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/ExploreView-contextMenu.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/ExploreView-with-search-word.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/ExploreView-contextMenu-with-search-word.png" width='25%' height='100%'/>

### [SavedView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Saved/SavedView.swift)

- if there's no posts saved in `Core Data`, click「Start browsing」could change tab to [`ExploreView`](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Explore/ExploreView.swift)
- only show post title & post thumbnail when `List`：`editMode.isEditing`

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/SavedView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/SavedView-with-saved-posts.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/EditNoteView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/SavedEntryRowView-onDelete.png" width='25%' height='100%'/>

### [AuthorView](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/Blogger/Views/Author/AuthorView.swift)

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/AuthorView-sheet.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/SettingView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/TagListView.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Easter%20eggs.png" width='25%' height='100%'/>

- if user click on version tag 5 times could change Blogger url in API to change this app's content！

### [Widget](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/BloggerWidget/BloggerWidget.swift)

> **Widgets**：iPad Pro（12.9-inch、5th generation）

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/widgets.jpg" width='100%' height='100%'/>

- 4 different size
- UI design like [Apple News](https://www.apple.com/apple-news/)
- data fetch from API to get the newest posts
- we also call API on `getSnapshot` in addition to `getTimeline`

### [Watch](https://github.com/5j54d93/Google-Blogger-iOS-App/tree/main/BloggerWatch%20WatchKit%20Extension)

> **watchOS**：Apple Watch Series 7 - 45mm

<img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-1.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-2.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-3.png" width='25%' height='100%'/><img src="https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/.github/assets/Watch-4.png" width='25%' height='100%'/>

- UI design with SwiftUI
- data fetch from API
- two clickable `Button` in a row of `List`

## License：MIT

This package is [MIT licensed](https://github.com/5j54d93/Google-Blogger-iOS-App/blob/main/LICENSE).
