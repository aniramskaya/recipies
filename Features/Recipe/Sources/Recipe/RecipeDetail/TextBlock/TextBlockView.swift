//
//  TextBlockView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI

struct TextBlockView: View {
    let model: TextBlockViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.medium) {
            if let title = model.title {
                Text(title)
                    .font(.title2)
                    .bold()
                    .accessibilityIdentifier(A11y.title)
            }
            Text(model.text)
                .accessibilityIdentifier(A11y.text)
        }
        .padding(RecipeStyles.Padding.default)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = TextBlockViewA11y

enum TextBlockViewA11y {
    static let component = "TextBlockView"
    static let title = "TextBlockViewTitle"
    static let text = "TextBlockViewText"
}
