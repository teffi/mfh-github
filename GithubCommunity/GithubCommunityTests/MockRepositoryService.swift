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
    
    func getUsers() async -> Result<[User], Error> {
        Self.getUsersCallCount += 1
        return .success([User(id: 1, login: "")])
    }
}
