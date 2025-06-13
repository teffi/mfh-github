//
//  Data.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/13/25.
//

import Foundation

extension Data {
    func prettyPrint() {
        do {
            let object = try JSONSerialization.jsonObject(with: self)
            let prettyPrintedData = try JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            )
            print(String(decoding: prettyPrintedData, as: UTF8.self))
        } catch {
            print("failed to print json data")
        }
    }
}
