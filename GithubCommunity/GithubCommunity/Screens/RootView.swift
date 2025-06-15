//
//  RootView.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = RouterService()
    private let token = "{{INSERT TOKEN HERE}}"
    
    var body: some View {
        NavigationStack(path: $router.path) {
            UsersView(
                repositoryService: RepositoryService(apiService: APIService(token: token)),
                routerService: router
            ).navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .repo(let url):
                        RepoView(url: url)
                    case .userProfile(let profile):
                        UserProfileView(
                            user: profile,
                            repositoryService: RepositoryService(apiService: APIService(token: token)),
                            routerService: router
                        )
                    case .users:
                        UsersView(
                            repositoryService: RepositoryService(apiService: APIService(token: token)),
                            routerService: router
                        )
                    }
            }
        }
        .tint(.black)
    }
}
