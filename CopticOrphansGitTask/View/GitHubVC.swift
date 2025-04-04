//
//  GitHubVC.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 03/04/2025.
//

import UIKit

class GitHubVC: UIViewController {
    
    private let viewModel = GitHubViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        fetchRepositories()
    }
    
    private func setupUI() {
        navigationItem.hidesBackButton = true
        
        searchBar.delegate = self
        searchBar.placeholder = "Search repositories"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GitHubRepoCell.self, forCellReuseIdentifier: GitHubRepoCell.identifier)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchRepositories() {
        activityIndicator.startAnimating()
        print("Fetching repositories...")
        viewModel.fetchPublicRepositories { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print("Error is \(error)")
                    
                    // Create an alert to show the error message
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    
                    // Add OK button to dismiss the alert
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    // Present the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func searchRepositories(query: String) {
        activityIndicator.startAnimating()
        print("Query: \(query)")
        viewModel.searchRepositories(query: query) { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print("Error: \(error)")
                    
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension GitHubVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHubRepoCell.identifier, for: indexPath) as! GitHubRepoCell
        let repo = viewModel.repositories[indexPath.row]
        cell.configure(with: repo)
        
        if indexPath.row == viewModel.repositories.count - 1 { // Load more when reaching the last item
            if let query = searchBar.text, !query.isEmpty {
                searchRepositories(query: query)
            } else {
                fetchRepositories()
            }
        }
        
        return cell
    }
}

extension GitHubVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchRepositories(query: query)
    }
}
