//
//  UsersViewModel.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import Combine
import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let reposUrl: String
}

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published private(set) var isLoading = false
    
    private let repositoryService: RepositoryServiceProtocol
    private let routerService: RouterService
    
    init(repositoryService: RepositoryServiceProtocol = RepositoryService(), routerService: RouterService) {
        self.repositoryService = repositoryService
        self.routerService = routerService
    }
    
    func viewAppeared() {
        getUsers()
        print("view appeared")
    }
    
    func getUsers() {
        Task { @MainActor in
            isLoading = true
            defer { isLoading = false }
            switch await repositoryService.getUsers() {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("error " + error.localizedDescription)
                // TODO: Trigger of error state
            }
        }
    }
    
    func goToUser() {
        print("go to user")
        routerService.to(route: .user(restUrl: "sample link"))
    }
}
