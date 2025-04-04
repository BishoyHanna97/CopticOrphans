//
//  GitHubViewModel.swift
//  CopticOrphansGitTask
//
//  Created by Bishoy Hanna on 03/04/2025.
//

import Firebase
import Alamofire

class GitHubViewModel {
    var repositories: [Repository] = []
    var isLoading = false
    private var currentPage = 1
    
    func fetchPublicRepositories(completion: @escaping (String?) -> Void) {
        isLoading = true
        let url = "https://api.github.com/search/repositories?q=stars:0&1&2&3&4&5&sort=stars&page=\(currentPage)"
        
        AF.request(url).validate().responseDecodable(of: GitHubResponse.self) { response in
            self.isLoading = false
            switch response.result {
            case .success(let data):
                print("success")
                self.repositories.append(contentsOf: data.items)
                completion(nil)
            case .failure(let error):
                print("failed")
                let errorMessage = self.getGitHubErrorMessage(error)
                completion(errorMessage)
                print(errorMessage)
            }
        }
    }
    
    func searchRepositories(query: String, completion: @escaping (String?) -> Void) {
        isLoading = true
        currentPage = 1
        let trimmedQuery = query.replacingOccurrences(of: " ", with: "")

        let url = "https://api.github.com/search/repositories?q=\(trimmedQuery)&sort=stars&page=\(currentPage)"
        
        AF.request(url).validate().responseDecodable(of: GitHubResponse.self) { response in
            self.isLoading = false
            switch response.result {
            case .success(let data):
                print("success")
                self.repositories = []
                self.repositories = data.items
                completion(nil)
            case .failure(let error):
                let errorMessage = self.getGitHubErrorMessage(error)
                print(errorMessage)
                completion(errorMessage)
            }
        }
    }
    
    private func getGitHubErrorMessage(_ error: AFError) -> String {
        if let statusCode = error.responseCode {
            switch statusCode {
            case 403:
                return "Rate limit exceeded. Try again later."
            case 404:
                return "Repositories not found."
            default:
                return "Server error. Please try again."
            }
        }
        return "\(error)"
    }
}
