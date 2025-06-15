//
//  UserProfileViewModelTests.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/15/25.
//

import XCTest

@testable import GitHubCommunity
import Combine

final class UserProfileViewModelTests: XCTestCase {
    private var viewModel: UserProfileViewModel!
    
    override func setUpWithError() throws {
        let repositoryService = MockRepositoryService()
        let routerService = RouterService()

        let testUserProfile = UserProfile(id: 1, name: "test", blog: "test", login: "test", avatarUrl: "test", company: "test", location: "test", reposUrl: "test", followers: 1, following: 1)
        viewModel = UserProfileViewModel(user: testUserProfile,
                                         repositoryService: repositoryService,
                                         routerService: routerService)
    }

    
    //  Simple sample test:
    //  Evaluates if data is fetched on viewAppeared function.
    func testViewAppearedRetrievesData() throws {
        let statePublisher = viewModel.$repos
            .dropFirst()
            .collect(1)
            .first()        
        viewModel.viewAppeared()
        try awaitPublisher(statePublisher, timeout: 1)
        XCTAssertFalse(viewModel.repos.isEmpty)
    }
}
