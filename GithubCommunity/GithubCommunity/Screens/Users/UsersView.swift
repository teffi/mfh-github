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
                        Text("Meet the GitHub Community")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 20)
                        ForEach(viewModel.users) { user in
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(alignment: .top){
                                    AvatarView(url: URL(string: user.avatarUrl)!)
                                        .frame(width: 80, height: 80)
                                    Spacer()
                                    if let location = user.location {
                                        Label(location, systemImage: "mappin.and.ellipse")
                                            .font(.footnote)
                                    }
                                }                                
                                VStack(alignment: .leading, spacing: 8){
                                    Text(user.name)
                                        .bold()
                                        .font(.title2)
                                    Text("@\(user.login)")
                                    HStack(spacing: 8) {
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 20)
                            .card()
                            .onTapGesture {
                                viewModel.goToUser(user: user)
                            }
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
