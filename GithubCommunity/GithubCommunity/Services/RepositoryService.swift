//
//  RepositoryService.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import Foundation
protocol RepositoryServiceProtocol {
    var apiService: APIServiceProtocol { get }
    
    func getUsers() async -> Result<[User], Error>
}

class RepositoryService: RepositoryServiceProtocol {
    var apiService: APIServiceProtocol = APIService()
    
    func getUsers() async -> Result<[User], Error> {
        return await APIService().sendRequest(url: URL(string: "https://api.github.com/users")!, method: .get)
    }
}

