//
//  RepositoryService.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import Foundation
protocol RepositoryServiceProtocol {
    var apiService: APIServiceProtocol { get }
    
    func getUsers() async throws -> [User]
    func getUser(link: String) async throws -> UserProfile
    func getRepositories(link: String) async throws -> [Repository]
}

class RepositoryService: RepositoryServiceProtocol {
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getUsers() async throws -> [User] {
        return try await apiService.sendRequest(url: URL(string: "https://api.github.com/users")!, method: .get, body: nil, queries: nil)
    }
    
    func getUser(link: String) async throws -> UserProfile {
        return try await apiService.sendRequest(url: URL(string: link)!, method: .get, body: nil, queries: nil)
    }
    
    func getRepositories(link: String) async throws -> [Repository] {
        return try await apiService.sendRequest(url: URL(string: link)!, method: .get, body: nil, queries: nil)
    }
}

