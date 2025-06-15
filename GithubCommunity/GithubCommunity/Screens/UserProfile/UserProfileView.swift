//
//  UserView.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject private var viewModel: UserProfileViewModel
        
    init(
        user: UserProfile,
        repositoryService: RepositoryServiceProtocol,
        routerService: RouterService
        
    ) {
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user, repositoryService: repositoryService, routerService: routerService))
    }
    
    @ViewBuilder
    var placeholdersView: some View {
        VStack(spacing: 24) {
            ForEach(0...6,  id: \.self) { _ in
                VStack(alignment: .leading, spacing: 10){
                    Color(.systemGray5)
                        .frame(maxWidth: .infinity, minHeight: 14, maxHeight: 14)
                    Color(.systemGray5)
                        .frame(maxWidth: 200, minHeight: 14, maxHeight: 14)
                }
            }
        }
    }
    
    @ViewBuilder
    var repositoryHeaderView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Repositories")
                    .font(.title3)
                    .bold()
                Text("\(viewModel.repos.count)")
                    .font(.caption)
                    .padding(3)
                    .background(.gray.opacity(0.1), in: .circle)
            }
            Toggle("Include forks", isOn: $viewModel.showForkedRepos)
                .toggleStyle(CheckboxToggleStyle())
                .padding(.bottom, 12)
        }
    }
    
    @ViewBuilder
    var userInfoView: some View {
        VStack(alignment:.center, spacing: 20) {
            AvatarView(url: URL(string: viewModel.user.avatarUrl)!)
                .frame(width: 120, height: 120)
            VStack(alignment: .center, spacing: 8){
                Text(viewModel.user.name ?? "_")
                    .font(.title2)
                    .bold()
                Text("@\(viewModel.user.login)")
                    .font(.title3)
//                    .background(.gray.opacity(0.1), in: .circle)
                
                HStack(spacing: 16){
                    Label("\(viewModel.user.followers) followers", systemImage: "person.2")
                    Label("\(viewModel.user.following) following", systemImage: "person.2.wave.2")
//                        .font(.caption2)
                }
                .font(.subheadline)

            }.frame(maxWidth: .infinity)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func repositoryItemView(_ repo: Repository) -> some View {
        VStack(alignment: .leading, spacing: 10){
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "shippingbox")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: 30, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    
                    
                VStack (alignment: .leading, spacing: 6) {
                    Text(repo.name)
                        .font(.headline)
                    Text(repo.fullName)
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.8))
                }
            }
            
            Text(repo.description ?? "No description.")
                .font(.subheadline)
            
            HStack {
                if let lang = repo.language {
                    Label {
                        Text(lang)
                            .font(.caption)
                            .foregroundStyle(.black.opacity(0.8))
                    } icon: {
                        Circle()
                            .fill(Color.random.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                Spacer()
                HStack(alignment: .center, spacing: 2){
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.yellow)
                    Text("\(repo.stargazersCount) stars")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.8))
                }
            }
        }
        
        Divider()
    }
        
    var body: some View {
        ZStack(alignment: .bottom) {

            
            VStack {
                ScrollView {
                    LazyVStack {
                        userInfoView
                        repositoryHeaderView
                            .padding(.vertical, 20)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        // Repositories
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.repos) { repo in
                                repositoryItemView(repo)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.goToRepo(url: repo.htmlUrl)
                                    }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        
                        if viewModel.isLoading {
                            ZStack {
                               placeholdersView
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
               
            }
        }
        .onAppear {
            viewModel.viewAppeared()
        }
    }
}

