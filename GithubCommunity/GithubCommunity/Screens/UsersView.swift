//
//  UsersList.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/13/25.
//

import SwiftUI
import Combine

struct UsersListView: View {
    @StateObject var viewModel: UsersListViewModel = UsersListViewModel()
    
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


class UsersListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published private(set) var isLoading = false
    
    func viewAppeared() {
        getUsers()
        print("view appeared")
    }
    
    func getUsers() {
        Task { @MainActor in
            
            isLoading = true
            defer { isLoading = false }            
            let result: Result<[User], Error> = await APIService().sendRequest(url: URL(string: "https://api.github.com/users")!, method: .get)
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("error " + error.localizedDescription)
                // TODO: Trigger of error state
            }
        }
    }
}

struct User: Identifiable, Decodable {
    let id: Int
    let login: String
}

//#Preview {
//    ContentView()
//}
