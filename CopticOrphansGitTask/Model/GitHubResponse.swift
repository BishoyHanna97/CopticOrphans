//
//  GitHubResponse.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 03/04/2025.
//

struct GitHubResponse: Decodable {
    let items: [Repository]
}

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let owner: Owner
    let html_url: String
    let stargazers_count: Int  // ⭐ New Attribute
}

struct Owner: Decodable {
    let login: String
}
