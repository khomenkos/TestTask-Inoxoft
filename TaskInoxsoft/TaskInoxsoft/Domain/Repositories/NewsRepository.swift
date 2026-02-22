//
//  NewsRepository.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

protocol NewsRepository {
    func fetchNews(query: String, page: Int, pageSize: Int, sortBy: SortBy) async throws -> ArticlesListing
    func fetchCachedArticles() throws -> [Article]
}
