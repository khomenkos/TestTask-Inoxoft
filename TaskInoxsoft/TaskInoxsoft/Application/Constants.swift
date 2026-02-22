//
//  Constants.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

enum Constants {
    enum API {
        static let baseURL = "https://newsapi.org/v2"
        static var apiKey: String {
            return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        }
    }
}
