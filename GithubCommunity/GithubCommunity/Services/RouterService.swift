//
//  Router.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

class RouterService: ObservableObject {
    @Published var path = NavigationPath()
    
    var canGoBack: Bool {
        return path.count > 0
    }
    
    func toRoot() {
        path.removeLast(path.count)
    }
    
    func to(route: AppRoute) {
        path.append(route)
    }
    
    func back() {
        path.removeLast()
    }
}

enum AppRoute: Hashable {
    case users
    case userProfile(user: UserProfile)
    case repo(url: URL)
}
