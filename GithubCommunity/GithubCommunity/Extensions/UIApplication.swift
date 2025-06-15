//
//  UIApplication.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/15/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
