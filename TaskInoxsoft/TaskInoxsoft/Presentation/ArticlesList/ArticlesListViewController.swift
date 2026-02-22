//
//  ArticlesListViewController.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit

@MainActor
protocol ArticlesListViewControllerDelegate: AnyObject {
    func articlesListViewController(_ viewController: ArticlesListViewController, didSelectArticle article: Article)
}

final class ArticlesListViewController: UIViewController {
    private let viewModel: ArticlesListViewModelProtocol
    weak var delegate: ArticlesListViewControllerDelegate?
    
    private var articles: [Article] = []
    
    private let paginationThreshold: CGFloat = 1200
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let footerLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: ArticlesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadInitial()
    }
    
    private func setupUI() {
        title = "Latest News"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Search
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        footerLoadingIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        tableView.tableFooterView = footerLoadingIndicator
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.handleStateChange(state)
        }
    }
    
    private func handleStateChange(_ state: ArticlesListState) {
        switch state {
        case .idle:
            break
        case .loading:
            handleLoadingState()
        case .loadingMore:
            handleLoadingMoreState()
        case .loaded(let newArticles):
            handleLoadedState(with: newArticles)
        case .empty:
            handleEmptyState()
        case .error(let message):
            handleErrorState(with: message)
        }
    }
    
    private func handleLoadingState() {
        tableView.isHidden = articles.isEmpty
        errorLabel.isHidden = true
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
    }
    
    private func handleLoadingMoreState() {
        footerLoadingIndicator.startAnimating()
        tableView.tableFooterView?.isHidden = false
    }
    
    private func handleLoadedState(with newArticles: [Article]) {
        self.articles = newArticles
        tableView.isHidden = false
        errorLabel.isHidden = true
        loadingIndicator.stopAnimating()
        footerLoadingIndicator.stopAnimating()
        tableView.tableFooterView?.isHidden = true
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func handleEmptyState() {
        tableView.isHidden = true
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        errorLabel.text = "No articles found.\nTry a different search."
        errorLabel.isHidden = false
    }
    
    private func handleErrorState(with message: String) {
        tableView.isHidden = articles.isEmpty
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
        if articles.isEmpty {
            errorLabel.text = "Oops! Something went wrong:\n\(message)"
            errorLabel.isHidden = false
        }
    }
    
    @objc private func handleRefresh() {
        viewModel.refresh()
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        delegate?.articlesListViewController(self, didSelectArticle: article)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Load more when within paginationThreshold of the bottom
        if offsetY > (contentHeight - frameHeight - paginationThreshold) && contentHeight > frameHeight {
            viewModel.loadMore()
        }
    }
}

// MARK: - UISearchBarDelegate
extension ArticlesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.search(query: text)
        searchController.dismiss(animated: true)
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.search(query: "")
            tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(query: "")
        tableView.setContentOffset(.zero, animated: true)
    }
}
