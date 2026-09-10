//
//  RecipeStyles.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 26.07.2026.
//

import UIKit
import SwiftUI

enum RecipeStyles {
    enum Padding {
        static let `default`: CGFloat = 20
        static let mulilineText: CGFloat = 12
        static let singleLineText = EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10)
    }
    
    enum Spacing {
        static let medium: CGFloat = 16
        static let small: CGFloat = 12
        static let xSmall: CGFloat = 6
    }
    
    enum Radius {
        static let medium: CGFloat = 12
        static let small: CGFloat = 8
    }
    
    static let titlePadding = EdgeInsets(top: 16, leading: 20, bottom: 12, trailing: 20)
}
