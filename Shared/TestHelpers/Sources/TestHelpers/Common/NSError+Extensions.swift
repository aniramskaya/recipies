//
//  NSError+Extensions.swift
//  RecipeList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public extension NSError {
    static func any() -> NSError {
        NSError(domain: UUID().uuidString, code: 1)
    }
}
