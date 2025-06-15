//
//  Colors.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/14/25.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
