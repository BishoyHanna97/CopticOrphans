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
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add the activity indicator and error label to the view
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .red
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        // Create a stack view to contain search bar and table view
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Activate constraints for activity indicator, error label, and stack view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchRepositories() {
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
        viewModel.fetchPublicRepositories { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.errorLabel.text = error
                    self.errorLabel.isHidden = false
                } else {
                    self.errorLabel.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func searchRepositories(query: String) {
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
        viewModel.searchRepositories(query: query) { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.errorLabel.text = error
                    self.errorLabel.isHidden = false
                } else {
                    self.errorLabel.isHidden = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.repositories[indexPath.row].name
        
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
