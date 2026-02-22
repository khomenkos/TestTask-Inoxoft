//
//  ImageActivityItemSource.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit
import LinkPresentation

// MARK: - Activity Item Source for Image Preview & Saving
final class ImageActivityItemSource: NSObject, UIActivityItemSource {
    let imageURL: URL
    let image: UIImage
    let title: String

    init(imageURL: URL, image: UIImage, title: String) {
        self.imageURL = imageURL
        self.image = image
        self.title = title
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return imageURL
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return imageURL
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.imageProvider = NSItemProvider(object: image)
        metadata.iconProvider = NSItemProvider(object: image)
        return metadata
    }
}
