//
//  UserViewModel.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import Foundation
import Combine

struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let url: String
    let fork: Bool
}

@MainActor
class UserViewModel: ObservableObject {
    private let repositoryService: RepositoryServiceProtocol
    private let routerService: RouterService
    @Published var user: UserProfile
    @Published var repos: [Repository] = []
    @Published var showForkedRepos = false
    private var cancellables = Set<AnyCancellable>()
    
    init(
        user: UserProfile,
        repositoryService: RepositoryServiceProtocol = RepositoryService(),
        routerService: RouterService
    ) {
        self.user = user
        self.repositoryService = repositoryService
        self.routerService = routerService
        setupObservers()
    }
    
    func viewAppeared() {
        getRepositories()
    }
    
    func setupObservers() {
        $showForkedRepos
            .dropFirst()
            .sink { [weak self] _ in
                self?.getRepositories()
        }.store(in: &cancellables)
    }
    
    func getRepositories() {
        Task {
            do {
                let result = try await repositoryService.getRepositories(link: user.reposUrl)
                repos = showForkedRepos ? result : result.filter { !$0.fork }                
            } catch {
                print("Error fetching repositories: \(error)")
            }
        }
    }
}
