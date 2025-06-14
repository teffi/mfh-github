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

struct UserProfile: Identifiable, Decodable {
    let id: Int
    let name: String
    let login: String
    let avatarUrl: String
    let reposUrl: String
    let followers: Int
}


@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [UserProfile] = []
    @Published private(set) var isLoading = false
    
    private let repositoryService: RepositoryServiceProtocol
    let routerService: RouterService
    
    init(repositoryService: RepositoryServiceProtocol = RepositoryService(), routerService: RouterService) {
        self.repositoryService = repositoryService
        self.routerService = routerService
    }
    
    func viewAppeared() {
        getUsers()
        print("view appeared")
    }
    
    func getUsers() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                users = try await withThrowingTaskGroup(of: UserProfile.self, returning: [UserProfile].self) { group in
                    // Get all users
                    let userUrls = try await self.repositoryService.getUsers().map { $0.url }

                    // Get profile per user
                    for url in userUrls {
                        //Return user profile per user url.
                        group.addTask {
                            try await self.repositoryService.getUser(link: url)
                        }
                    }
                    
                    return try await group.reduce(into: [UserProfile]()) { partialResult, profile in
                        partialResult.append(profile)
                    }
                    
                }
            } catch {
                print(error)
            }
           
        }
        
    }
    
    func goToUser() {
        print("go to user")
        routerService.to(route: .user(restUrl: "sample link"))
    }
}
