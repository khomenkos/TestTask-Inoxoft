//
//  NetworkService.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation
import Alamofire

protocol NetworkService: AnyObject, Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T
}

final class AlamofireNetworkManager: NetworkService {
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        let url = Constants.API.baseURL + endpoint.path
        
        let task = session
            .request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                headers: endpoint.headers
            )
            .validate()
            .serializingDecodable(T.self)
        
        return try await task.value
    }
}
