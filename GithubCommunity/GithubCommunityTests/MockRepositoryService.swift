//
//  MockRepositoryService.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

@testable import GitHubCommunity
import Foundation

class MockRepositoryService: RepositoryServiceProtocol {
    var apiService: APIServiceProtocol = APIService()
    static var getUsersCallCount = 0
    
    init() {
        Self.getUsersCallCount = 0
    }
    
    func getUsers() async throws -> [GitHubCommunity.User] {
        return [User(id: 1, login: "test", avatarUrl: "test", url: "test", reposUrl: "test")]
    }
    
    func getUser(link: String) async throws -> GitHubCommunity.UserProfile {
        return UserProfile(id: 1, name: "test", blog: "test", login: "test", avatarUrl: "test", company: "test", location: "test", reposUrl: "test", followers: 1, following: 1)
    }
    
    func getRepositories(link: String) async throws -> [GitHubCommunity.Repository] {
        return [Repository(id: 1, name: "test", fullName: "test", description: "test", stargazersCount: 1, language: "test", url: "test", fork: false, htmlUrl: "test")]
    }
}
