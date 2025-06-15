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
    let htmlUrl: String
}

@MainActor
class UserProfileViewModel: ObservableObject {
    private let repositoryService: RepositoryServiceProtocol
    private let routerService: RouterService
    @Published var user: UserProfile
    @Published var repos: [Repository] = []
    @Published var showForkedRepos = false
    @Published private(set) var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(
        user: UserProfile,
        repositoryService: RepositoryServiceProtocol,
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
            isLoading = true
            defer { isLoading = false }
            
            do {
                let result = try await repositoryService.getRepositories(link: user.reposUrl)
                repos = showForkedRepos ? result : result.filter { !$0.fork }
            } catch {
                print("Error fetching repositories: \(error)")
            }
        }
    }    
    
    func goToRepo(url: String) {
        guard let url = URL(string: url) else { return }
        routerService.to(route: .repo(url: url))
    }
    
}
