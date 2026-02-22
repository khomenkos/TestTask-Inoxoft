//
//  NewsResponse.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

nonisolated
struct NewsResponse: Decodable, Sendable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable, Sendable {
    let source: SourceDTO
    let author: String?
    let title: String
    let description: String?
    let content: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String 
}

struct SourceDTO: Decodable, Sendable {
    let id: String?
    let name: String
}
