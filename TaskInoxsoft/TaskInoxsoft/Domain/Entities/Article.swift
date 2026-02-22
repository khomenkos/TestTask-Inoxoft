//
//  Article.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

struct Article: Equatable {
    let id: String
    let title: String
    let author: String?
    let description: String?
    let content: String?
    let publishedAt: Date
    let url: URL
    let urlToImage: URL?
    let sourceName: String
    
    var displayContent: String {
        content ?? description ?? "No content available."
    }
    
    var dateString: String {
        DateFormatter.articleDateFormatter.string(from: publishedAt)
    }
    
    var relativeDateString: String {
        RelativeDateTimeFormatter.articleRelativeFormatter.localizedString(for: publishedAt, relativeTo: Date())
    }
}
