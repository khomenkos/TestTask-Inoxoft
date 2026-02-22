//
//  ArticleDetailView.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit
import Kingfisher

protocol ArticleDetailViewDelegate: AnyObject {
    func articleDetailViewDidTapShowMore(_ view: ArticleDetailView)
    func articleDetailViewDidTapDownload(_ view: ArticleDetailView, image: UIImage?)
}

final class ArticleDetailView: UIView {
    
    weak var delegate: ArticleDetailViewDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read Full Article", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShowMore), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadImageButton: UIButton = {
        let button = UIButton(type: .system)
        var cfg = UIButton.Configuration.filled()
        cfg.imagePadding = 0
        cfg.image = UIImage(systemName: "arrow.down.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 28))
        cfg.baseBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        cfg.baseForegroundColor = .white
        cfg.cornerStyle = .capsule
        button.configuration = cfg
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDownloadImage), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        backgroundColor = .systemBackground

        // Hierarchy
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(articleImageView)
        articleImageView.addSubview(downloadImageButton)
        
        infoStack.addArrangedSubview(sourceLabel)
        infoStack.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(infoStack)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(showMoreButton)
        
        showMoreButton.heightAnchor.constraint(equalToConstant: 54).isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            articleImageView.heightAnchor.constraint(equalToConstant: 250),
            
            downloadImageButton.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: -8),
            downloadImageButton.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: -8),
            downloadImageButton.widthAnchor.constraint(equalToConstant: 44),
            downloadImageButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        contentLabel.text = article.content
        sourceLabel.text = article.sourceName
        dateLabel.text = article.dateString
        authorLabel.text = article.author.flatMap { "By \($0)" }
        authorLabel.isHidden = article.author == nil
        
        articleImageView.kf.indicatorType = .activity
        let placeholder = UIImage.kingfisherPlaceholder(pointSize: 60)
            
        if let url = article.urlToImage {
            articleImageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [.transition(.fade(0.3))]
            ) { [weak self] result in
                switch result {
                case .success:
                    self?.downloadImageButton.isHidden = false
                case .failure:
                    self?.downloadImageButton.isHidden = true
                }
            }
        } else {
            articleImageView.image = placeholder
            downloadImageButton.isHidden = true
        }
    }
    
    @objc private func handleShowMore() {
        delegate?.articleDetailViewDidTapShowMore(self)
    }

    @objc private func handleDownloadImage() {
        delegate?.articleDetailViewDidTapDownload(self, image: articleImageView.image)
    }
}
