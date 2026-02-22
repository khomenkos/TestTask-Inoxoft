//
//  NewsLocalDataSource.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import RealmSwift

protocol NewsLocalDataSource: Sendable {
    func fetchCachedArticles() throws -> [Article]
    func save(articles: [Article]) throws
}

final class NewsRealmDataSource: NewsLocalDataSource {
    private let realmCache: Realm?
    
    init(realm: Realm?) {
        self.realmCache = realm
    }

    func fetchCachedArticles() throws -> [Article] {
        guard let realm = realmCache else { return [] }
        let objects = realm.objects(ArticleObject.self).sorted(byKeyPath: "publishedAt", ascending: false)
        return objects.compactMap { $0.toDomain() }
    }

    func save(articles: [Article]) throws {
        guard let realm = realmCache else { return }
        let objects = articles.map { ArticleObject.from(domain: $0) }
        try realm.write {
            realm.add(objects, update: .modified)
        }
    }
}
