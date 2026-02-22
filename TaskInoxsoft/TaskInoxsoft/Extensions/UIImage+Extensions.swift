//
//  UIImage+Extensions.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit

extension UIImage {
    static func kingfisherPlaceholder(pointSize: CGFloat) -> UIImage? {
        UIImage(systemName: "photo.on.rectangle.angled")?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: pointSize))
    }
}
