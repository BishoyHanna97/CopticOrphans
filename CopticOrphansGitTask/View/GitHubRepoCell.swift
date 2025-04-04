//
//  GitHubRepoCell.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 04/04/2025.
//

import UIKit

class GitHubRepoCell: UITableViewCell {
    
    static let identifier = "GitHubRepoCell"
    
    private let repoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemYellow
        return label
    }()
    
    private let repoIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "folder.fill"))
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [repoIcon, repoNameLabel, starsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        let verticalStack = UIStackView(arrangedSubviews: [stackView, ownerLabel])
        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        
        contentView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repoIcon.widthAnchor.constraint(equalToConstant: 24),
            repoIcon.heightAnchor.constraint(equalToConstant: 24),
            
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with repo: Repository) {
        repoNameLabel.text = repo.name
        ownerLabel.text = "By \(repo.owner.login)"
        starsLabel.text = "⭐ \(repo.stargazers_count)"
    }
}
