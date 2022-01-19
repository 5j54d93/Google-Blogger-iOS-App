//
//  BloggerWidgetJSONModel.swift
//  BloggerWidgetExtension
//
//  Created by 莊智凱 on 2022/1/9.
//

import WidgetKit
import SwiftUI

struct Entry: TimelineEntry {
    let date: Date
    let entry: [Entries]
    let uiImage: [UIImage]
}
