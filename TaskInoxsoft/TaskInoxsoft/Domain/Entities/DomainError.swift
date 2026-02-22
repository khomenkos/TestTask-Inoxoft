//
//  DomainError.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

enum DomainError: Error, LocalizedError {
    case apiLimitReached
    
    var errorDescription: String? {
        switch self {
        case .apiLimitReached:
            return "Developer API limit reached. Upgrade Required."
        }
    }
}
