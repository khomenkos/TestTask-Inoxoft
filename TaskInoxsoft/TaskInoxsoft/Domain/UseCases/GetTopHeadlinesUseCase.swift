//
//  GetTopHeadlinesUseCase.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

protocol GetTopHeadlinesUseCaseProtocol: Sendable {
    func execute(query: String, page: Int, pageSize: Int, sortBy: SortBy) async throws -> ArticlesListing
}

final class GetTopHeadlinesUseCase: GetTopHeadlinesUseCaseProtocol {
    private let repository: NewsRepository

    init(repository: NewsRepository) {
        self.repository = repository
    }

    func execute(query: String = "", page: Int = 1, pageSize: Int = 20, sortBy: SortBy = .publishedAt) async throws -> ArticlesListing {
        try await repository.fetchNews(query: query, page: page, pageSize: pageSize, sortBy: sortBy)
    }
}
