//
//  String+Extensions.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import Foundation

extension String {
    var safeFilename: String {
        let safe = self.components(separatedBy: .alphanumerics.inverted).joined(separator: "_")
        return safe.isEmpty ? "File" : safe
    }
}
