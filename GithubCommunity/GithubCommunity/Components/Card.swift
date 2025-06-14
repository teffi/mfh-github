//
//  Card.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//
import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background()
            .cornerRadius(11)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.125), radius: 11)
    }
}

public extension View {
    func card() -> some View {
        modifier(CardModifier())
    }
}
