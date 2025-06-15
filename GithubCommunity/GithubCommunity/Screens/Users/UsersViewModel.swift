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
    let name: String?
    let blog: String?
    let login: String
    let avatarUrl: String
    let company: String?
    let location: String?
    let reposUrl: String
    let followers: Int
    let following: Int
}

@MainActor
class UsersViewModel: ObservableObject {
    /// Data displayed in view (filtered and unfiltered)
    @Published var users: [UserProfile] = []
    /// Stores all data
    @Published private var storedProfiles: [UserProfile] = []
    @Published var searchQuery = ""
    @Published private(set) var isLoading = false
    @Published private(set) var showNoResults = false
    private var cancellables = Set<AnyCancellable>()
    private let repositoryService: RepositoryServiceProtocol
    private let routerService: RouterService
    
    init(repositoryService: RepositoryServiceProtocol, routerService: RouterService) {
        self.repositoryService = repositoryService
        self.routerService = routerService
        setupObservers()
    }
    
    func viewAppeared() {
        getUsers()
    }
    
    func setupObservers() {
        //  Keep displayed data and stored data insync.
        $storedProfiles
            .dropFirst() // drop first assignment on init ([])
            .sink { [weak self] profiles in
                self?.users = profiles
            }
            .store(in: &cancellables)
        
        //  Lookup matching username in stored data and update display data
        $searchQuery
            .combineLatest($storedProfiles)
            .map{ (query, profiles) -> [UserProfile] in
                guard !query.isEmpty else {
                    return profiles
                }
                return profiles.filter {
                    $0.login.lowercased().contains(query.lowercased())
                }
            }
            .sink { [weak self] filteredProfiles in
                self?.users = filteredProfiles
                
                self?.showNoResults = filteredProfiles.isEmpty
            }
            .store(in: &cancellables)
    }
    
    /// Retrieve list of users and each user's profile.
    func getUsers() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                storedProfiles = try await withThrowingTaskGroup(of: (offset: Int, value: UserProfile).self, returning: [UserProfile].self) { group in
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
                    // Sort profiles back to their original order from api.
                    return result.sorted{ $0.offset < $1.offset }.map{ $0.value }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func goToUser(user: UserProfile) {
        routerService.to(route: .userProfile(user: user))
    }
    
    func resetSearch() {
        searchQuery = ""
    }
}
