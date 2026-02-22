//
//  ArticleObject.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import RealmSwift
internal import Realm

final class ArticleObject: Object {
    @Persisted(primaryKey: true) var url: String = ""
    @Persisted var title: String = ""
    @Persisted var author: String?
    @Persisted var articleDescription: String?
    @Persisted var content: String?
    @Persisted var publishedAt: Date = Date()
    @Persisted var urlToImage: String?
    @Persisted var sourceName: String = ""
    @Persisted var cachedAt: Date = Date()

    nonisolated override init() {
        super.init()
    }
    
    static func from(domain: Article) -> ArticleObject {
        let obj = ArticleObject()
        obj.url = domain.url.absoluteString
        obj.title = domain.title
        obj.author = domain.author
        obj.articleDescription = domain.description
        obj.content = domain.content
        obj.publishedAt = domain.publishedAt
        obj.urlToImage = domain.urlToImage?.absoluteString
        obj.sourceName = domain.sourceName
        obj.cachedAt = Date()
        return obj
    }

    func toDomain() -> Article? {
        guard let url = URL(string: self.url) else { return nil }
        return Article(
            id: self.url,
            title: title,
            author: author,
            description: articleDescription,
            content: content,
            publishedAt: publishedAt,
            url: url,
            urlToImage: urlToImage.flatMap(URL.init),
            sourceName: sourceName
        )
    }
}
