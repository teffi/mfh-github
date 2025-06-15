//
//  CheckboxToggleStyle.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/15/25.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.diamond.fill" : "diamond")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .black : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
                .font(.subheadline)
        }

    }
}
