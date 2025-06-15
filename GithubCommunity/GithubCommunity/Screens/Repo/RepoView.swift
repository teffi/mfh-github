//
//  RepoView.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//
import SwiftUI

struct RepoView: View {    
    let url: URL
    
    var body: some View {
        VStack {
            WKWebViewUI(url: url)
        }                
    }
}
