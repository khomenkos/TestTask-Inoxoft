//
//  ArticleDetailViewModel.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

@MainActor
protocol ArticleDetailViewModelProtocol {
    var article: Article { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelProtocol {
    let article: Article
    
    init(article: Article) {
        self.article = article
    }
}
