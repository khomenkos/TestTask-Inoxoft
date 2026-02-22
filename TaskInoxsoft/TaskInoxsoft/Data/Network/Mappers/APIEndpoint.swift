//
//  APIEndpoint.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import Alamofire

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: any Sendable]? { get }
    var headers: HTTPHeaders? { get }
}

enum NewsEndpoint: APIEndpoint {
    case everything(query: String, page: Int, pageSize: Int, sortBy: String)
    
    var path: String {
        switch self {
        case .everything:
            return "/everything"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: any Sendable]? {
        switch self {
        case .everything(let query, let page, let pageSize, let sortBy):
            let params: [String: any Sendable] = [
                "q": query,
                "page": page,
                "pageSize": pageSize,
                "sortBy": sortBy,
                "apiKey": Constants.API.apiKey
            ]
            return params
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
