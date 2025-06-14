//
//  AvatarView.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

struct AvatarView: View {
    let url: URL
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "photo.fill")
        }     
        .clipShape(Circle())
    }
}
