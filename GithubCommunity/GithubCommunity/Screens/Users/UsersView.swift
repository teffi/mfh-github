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
                        
                        searchView
                       
                        ForEach(viewModel.users) { user in
                            userCardView(user)
                                .onTapGesture {
                                    viewModel.goToUser(user: user)
                                }
                        }
                        if viewModel.isLoading {
                            ZStack { placeholderCardsView }
                        } else if viewModel.showNoResults {
                            VStack { noFilterResultView }
                                .frame(height: 400)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onAppear(perform: viewModel.viewAppeared)        
    }
}

extension UsersView {
    
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
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(20)
        .card()
    }
    
    @ViewBuilder var searchView: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Filter:")
                .foregroundStyle(.white)
                .font(.headline)
            TextField("@username", text: $viewModel.searchQuery)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .overlay(alignment: .trailing) {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.black)
                        .offset(x: -10)
                        .opacity(viewModel.searchQuery.isEmpty ? 0 : 1)
                        .onTapGesture {
                            viewModel.resetSearch()
                            UIApplication.shared.endEditing()
                        }
                }
        }
    }
    
    @ViewBuilder var noFilterResultView: some View {        
        Text("Oops!\nWe can't find a match with that username.")
            .font(.title2)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    ContentView()
//}
