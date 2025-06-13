//
//  UsersList.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/13/25.
//

import SwiftUI
import Combine

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel(repositoryService: RepositoryService())
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.users) { user in
                            Text(user.login)
                        }
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .tint(.gray)
            }
        }
        .onAppear(perform: viewModel.viewAppeared)        
    }
}

//#Preview {
//    ContentView()
//}
