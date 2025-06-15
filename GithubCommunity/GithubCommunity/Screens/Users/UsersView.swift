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
    
    @ViewBuilder
    var placeholderCardsView: some View {
        VStack(spacing: 24) {
            ForEach(0...6,  id: \.self) { _ in
                Color(.systemGray5)
                    .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
                    .card()
            }
        }
    }
    
    @ViewBuilder
    func userCardView(_ user: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top){
                AvatarView(url: URL(string: user.avatarUrl)!)
                    .frame(width: 60, height: 60)
                Spacer()
                
                VStack(alignment: .trailing) {
                    if let location = user.location {
                        Label(location, systemImage: "mappin.and.ellipse")
                            .font(.footnote)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 8){
                Text(user.name ?? "_")
                    .font(.headline)
                    .bold()
                HStack {
                    Text("@\(user.login)")
                    Spacer()
                    Label("\(user.followers)", systemImage: "person.2")
                        .font(.footnote)
//                    HStack(spacing: 4){
//                        Image(systemName: "person.2")
//                        Text("\(user.followers) followers")
//                            .font(.subheadline)
//                    }
                }
               
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(20)    
        .card()
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Image("banner", bundle: nil)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        Text("Meet the GitHub Community")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.top, 20)
                                              
                        ForEach(viewModel.users) { user in
                            userCardView(user)
                                .onTapGesture {
                                    viewModel.goToUser(user: user)
                                }
                        }

                        if viewModel.isLoading {
                            ZStack {
                               placeholderCardsView
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onAppear(perform: viewModel.viewAppeared)        
    }
}

//#Preview {
//    ContentView()
//}
