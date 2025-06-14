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

struct UserProfile: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let login: String
    let avatarUrl: String
    let location: String?
    let reposUrl: String
    let followers: Int
    let following: Int
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
    
    /// Retrieve list of users and each user's profile.
    func getUsers() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                users = try await withThrowingTaskGroup(of: (offset: Int, value: UserProfile).self, returning: [UserProfile].self) { group in
                    // Get all users
                    let userUrls = try await self.repositoryService.getUsers().map { $0.url }
                    
                    // Store user profile in tuple with original index
                    for (idx, url) in userUrls.enumerated() {
                        group.addTask {
                            (idx, try await self.repositoryService.getUser(link: url))
                        }
                    }
                    
                    var result = [(offset: Int, value: UserProfile)]()
                    while let next = try await group.next() {
                        result.append(next)
                    }
                    // Return sorted profiles
                    return result.sorted{ $0.offset < $1.offset }.map{ $0.value }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func goToUser(user: UserProfile) {
        print("go to user")
        routerService.to(route: .userProfile(user: user))
    }
}
