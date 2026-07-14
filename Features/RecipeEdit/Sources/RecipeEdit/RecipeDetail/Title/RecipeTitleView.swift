//
//  RecipeTitleView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI

struct RecipeTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .accessibility(identifier: RecipeTitleViewA11y.component)
    }
}

enum RecipeTitleViewA11y {
    static let component = "RecipeDescriptionTitle"
}
