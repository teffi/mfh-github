//
//  UsersList.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/13/25.
//

import SwiftUI
import Combine

struct UsersView: View {
    @StateObject var viewModel: UsersViewModel
    
    init(repositoryService: RepositoryService, routerService: RouterService) {
        _viewModel = StateObject(wrappedValue: UsersViewModel(repositoryService: repositoryService, routerService: routerService))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(viewModel.users) { user in
//                            UserPreview(repositoryService: RepositoryService(), routerService: viewModel.routerService)

                            
                            Button{
                                //viewModel.goToUser()
                            } label: {
                            
                                HStack(spacing: 14) {
                                    AsyncImage(url: URL(string: user.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Image(systemName: "photo.fill")
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    Text(user.login)
                                    Text(user.name)
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 20)
                            .card()
                            
                        }
                    }
                    .padding(.horizontal, 24)
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
