//
//  DateFormatter+Extensions.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

extension DateFormatter {
    static let articleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

extension RelativeDateTimeFormatter {
    static let articleRelativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
}

extension ISO8601DateFormatter {
    static let shared: ISO8601DateFormatter = {
        return ISO8601DateFormatter()
    }()
}
