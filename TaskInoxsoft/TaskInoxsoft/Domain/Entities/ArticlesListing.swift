//
//  ArticlesListing.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

struct ArticlesListing {
    let articles: [Article]
    let totalResults: Int
    let page: Int
    
    var hasMore: Bool {
        articles.count < totalResults
    }
}
