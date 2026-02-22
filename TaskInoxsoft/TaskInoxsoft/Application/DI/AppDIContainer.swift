//
//  AppDIContainer.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import RealmSwift

// Manual DI root updated for News API.

final class AppDIContainer {

    // MARK: - Singletons

    private lazy var networkService: NetworkService = {
        AlamofireNetworkManager()
    }()

    private lazy var localDataSource: NewsLocalDataSource = {
        let realm: Realm?
        do {
            realm = try Realm()
        } catch {
            print("Failed to initialize Realm: \(error)")
            realm = nil
        }
        return NewsRealmDataSource(realm: realm)
    }()

    lazy var newsRepository: NewsRepository = {
        return NewsRepositoryImpl(networkService: networkService, localDataSource: localDataSource)
    }()

    // MARK: - Use Cases

    func makeGetTopHeadlinesUseCase() -> GetTopHeadlinesUseCaseProtocol {
        GetTopHeadlinesUseCase(repository: newsRepository)
    }

    func makeSearchNewsUseCase() -> SearchNewsUseCaseProtocol {
        SearchNewsUseCase(repository: newsRepository)
    }

    // MARK: - ViewModels

    func makeArticlesListViewModel() -> ArticlesListViewModelProtocol {
        ArticlesListViewModel(
            getTopHeadlines: makeGetTopHeadlinesUseCase(),
            searchNews: makeSearchNewsUseCase()
        )
    }

    func makeArticleDetailViewController(article: Article) -> ArticleDetailViewController {
        let viewModel = ArticleDetailViewModel(article: article)
        return ArticleDetailViewController(viewModel: viewModel)
    }
}
