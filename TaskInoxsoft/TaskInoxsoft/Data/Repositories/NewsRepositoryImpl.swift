//
//  NewsRepositoryImpl.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import Alamofire

final class NewsRepositoryImpl: NewsRepository {
    private let networkService: NetworkService
    private let localDataSource: NewsLocalDataSource
    
    init(networkService: NetworkService, localDataSource: NewsLocalDataSource) {
        self.networkService = networkService
        self.localDataSource = localDataSource
    }

    func fetchNews(query: String, page: Int, pageSize: Int, sortBy: SortBy) async throws -> ArticlesListing {
        do {
            let endpoint = NewsEndpoint.everything(
                query: query,
                page: page,
                pageSize: pageSize,
                sortBy: sortBy.rawValue
            )
            
            let response: NewsResponse = try await networkService.request(endpoint)
            return try mapAndCache(response: response, page: page)
        } catch {
            print("Fetch error: \(error)")
            
            // Handle NewsAPI free tier limit specifically (426 Upgrade Required)
            if let afError = error as? AFError,
               case .responseValidationFailed(let reason) = afError,
               case .unacceptableStatusCode(let code) = reason,
               code == 426 {
                throw DomainError.apiLimitReached
            }
            
            // Fallback to cache only on first page
            guard page == 1 else { throw error }
            
            let cached = try localDataSource.fetchCachedArticles().filter {
                if query.isEmpty { return true }
                return $0.title.lowercased().contains(query.lowercased()) || 
                ($0.description?.lowercased().contains(query.lowercased()) ?? false)
            }
            if cached.isEmpty { throw error }
            return ArticlesListing(articles: cached, totalResults: cached.count, page: page)
        }
    }
    
    func fetchCachedArticles() throws -> [Article] {
        return try localDataSource.fetchCachedArticles()
    }

    private func mapAndCache(response: NewsResponse, page: Int) throws -> ArticlesListing {
        let articles = response.articles.compactMap { dto -> Article? in
            guard let url = URL(string: dto.url),
                  let publishedAt = ISO8601DateFormatter.shared.date(from: dto.publishedAt) else { return nil }
            return Article(
                id: dto.url,
                title: dto.title,
                author: dto.author,
                description: dto.description,
                content: dto.content,
                publishedAt: publishedAt,
                url: url,
                urlToImage: dto.urlToImage.flatMap(URL.init),
                sourceName: dto.source.name
            )
        }

        try localDataSource.save(articles: articles)

        return ArticlesListing(
            articles: articles,
            totalResults: response.totalResults,
            page: page
        )
    }
}
