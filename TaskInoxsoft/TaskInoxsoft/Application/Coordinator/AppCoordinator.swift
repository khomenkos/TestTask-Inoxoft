//
//  AppCoordinator.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit
import SwiftUI

// Handles main navigation flow.

final class AppCoordinator {
    private let window: UIWindow
    private let diContainer: AppDIContainer
    private var navigationController: UINavigationController?

    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }

    func start() {
        let viewModel = diContainer.makeArticlesListViewModel()
        let vc = ArticlesListViewController(viewModel: viewModel)
        vc.delegate = self
        navigationController = UINavigationController(rootViewController: vc)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: ArticlesListViewControllerDelegate {
    func articlesListViewController(_ viewController: ArticlesListViewController, didSelectArticle article: Article) {
        let detailVC = diContainer.makeArticleDetailViewController(article: article)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension AppCoordinator: ArticleDetailViewControllerDelegate {
    func articleDetailViewController(_ viewController: ArticleDetailViewController, didRequestFullArticleFor url: URL) {
        let webView = ArticleWebView(url: url)
        let hostingController = UIHostingController(rootView: webView)
        viewController.present(hostingController, animated: true)
    }
}
