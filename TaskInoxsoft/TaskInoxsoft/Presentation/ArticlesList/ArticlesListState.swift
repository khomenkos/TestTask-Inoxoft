//
//  ArticlesListState.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

enum ArticlesListState: Equatable {
    case idle
    case loading
    case loadingMore
    case loaded([Article])
    case empty
    case error(String)
}
