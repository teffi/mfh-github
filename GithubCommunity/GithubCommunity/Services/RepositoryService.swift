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
}

class RepositoryService: RepositoryServiceProtocol {
    var apiService: APIServiceProtocol = APIService()
    
    func getUsers() async throws -> [User] {
        return try await APIService().sendRequest(url: URL(string: "https://api.github.com/users")!, method: .get, queries: ["per_page": "6"])
    }
    
    func getUser(link: String) async throws -> UserProfile {
        return try await APIService().sendRequest(url: URL(string: link)!, method: .get)
    }
}

