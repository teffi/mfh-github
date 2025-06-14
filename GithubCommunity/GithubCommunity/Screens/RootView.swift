//
//  RootView.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = RouterService()
    var repositoryService = RepositoryService()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            UsersView(repositoryService: repositoryService, routerService: router)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .repo(let restUrl):
                        RepoView()
                    case .user(let restUrl):
                        UserView()
                    case .users:
                        UsersView(repositoryService: RepositoryService(), routerService: router)
                    }
            }
        }
        .environmentObject(router)
    }
}
