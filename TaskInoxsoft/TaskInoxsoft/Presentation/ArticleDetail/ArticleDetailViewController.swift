//
//  ArticleDetailViewController.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit

protocol ArticleDetailViewControllerDelegate: AnyObject {
    func articleDetailViewController(_ viewController: ArticleDetailViewController, didRequestFullArticleFor url: URL)
}

final class ArticleDetailViewController: UIViewController {
    private let viewModel: ArticleDetailViewModelProtocol
    
    weak var delegate: ArticleDetailViewControllerDelegate?
    
    private lazy var detailView = ArticleDetailView()

    init(viewModel: ArticleDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detailView.delegate = self
        detailView.configure(with: viewModel.article)
    }

    private func setupUI() {
        title = "Article"
        navigationItem.largeTitleDisplayMode = .never
    }
}

// MARK: - ArticleDetailViewDelegate
extension ArticleDetailViewController: ArticleDetailViewDelegate {
    func articleDetailViewDidTapShowMore(_ view: ArticleDetailView) {
        delegate?.articleDetailViewController(self, didRequestFullArticleFor: viewModel.article.url)
    }
    
    func articleDetailViewDidTapDownload(_ view: ArticleDetailView, image: UIImage?) {
        guard let image = image else { return }
        
        let title = viewModel.article.title
        let safeTitle = title.safeFilename.isEmpty || title.safeFilename == "File" ? "Article_Image" : title.safeFilename
        let fileName = String(safeTitle.prefix(30)) + ".jpg"
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: tempURL)
            
            let itemSource = ImageActivityItemSource(imageURL: tempURL, image: image, title: title)
            let activityVC = UIActivityViewController(activityItems: [itemSource], applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = { _, _, _, _ in
                try? FileManager.default.removeItem(at: tempURL)
            }
            
            present(activityVC, animated: true)
        } else {
            // Fallback if JPEG conversion fails
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityVC, animated: true)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
