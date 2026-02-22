//
//  ArticlesListViewModel.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

@MainActor
protocol ArticlesListViewModelProtocol: AnyObject {
    var onStateChange: ((ArticlesListState) -> Void)? { get set }
    var state: ArticlesListState { get }
    
    func loadInitial()
    func search(query: String)
    func loadMore()
    func refresh()
}

@MainActor
final class ArticlesListViewModel: ArticlesListViewModelProtocol {
    var onStateChange: ((ArticlesListState) -> Void)?

    private let getTopHeadlines: GetTopHeadlinesUseCaseProtocol
    private let searchNews: SearchNewsUseCaseProtocol

    private var articles: [Article] = []
    private var currentPage = 1
    private var totalResults = 0
    private var currentQuery = "bitcoin" // Default query explicitly set
    private var currentTask: Task<Void, Never>?
    
    private let pageSize = 20
    private let sortBy: SortBy = .publishedAt

    private(set) var state: ArticlesListState = .idle {
        didSet { onStateChange?(state) }
    }

    init(getTopHeadlines: GetTopHeadlinesUseCaseProtocol, searchNews: SearchNewsUseCaseProtocol) {
        self.getTopHeadlines = getTopHeadlines
        self.searchNews = searchNews
    }

    func loadInitial() {
        guard articles.isEmpty else {
            return
        }
        currentQuery = "bitcoin"
        resetPagination()
        performFetch()
    }

    func search(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let targetQuery = trimmed.isEmpty ? "bitcoin" : trimmed
        
        guard currentQuery != targetQuery else { return }
        
        currentQuery = targetQuery
        resetPagination()
        performFetch()
    }

    func loadMore() {
        guard state != .loading, state != .loadingMore else { return }
        guard articles.count < totalResults else { 
            return
        }
        state = .loadingMore
        currentPage += 1
        performFetch()
    }

    func refresh() {
        currentPage = 1
        currentTask?.cancel()
        performFetch(isRefresh: true)
    }

    private func resetPagination() {
        articles = []
        currentPage = 1
        state = .loading
        currentTask?.cancel()
    }

    private func performFetch(isRefresh: Bool = false) {
        currentTask = Task { await fetchPage(isRefresh: isRefresh) }
    }

    private func fetchPage(isRefresh: Bool) async {
        do {
            let listing = try await searchNews.execute(query: currentQuery, page: currentPage, pageSize: pageSize, sortBy: sortBy)
            
            totalResults = listing.totalResults
            
            if isRefresh || currentPage == 1 {
                articles = listing.articles
            } else {
                articles.append(contentsOf: listing.articles)
            }
            
            if articles.isEmpty {
                state = .empty
            } else {
                state = .loaded(articles)
            }
        } catch {
            guard !Task.isCancelled else { return }
            
            if let domainError = error as? DomainError, domainError == .apiLimitReached {
                totalResults = articles.count
                state = .loaded(articles)
            } else {
                state = .error(error.localizedDescription)
            }
        }
    }
}
