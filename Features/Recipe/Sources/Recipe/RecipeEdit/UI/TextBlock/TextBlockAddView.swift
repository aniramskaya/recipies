//
//  TextBlockAddView.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI

struct TextBlockAddView: View {
    let onAdd: () -> Void
    
    var body: some View {
        AddElementButton(
            action: onAdd,
            title: .textBlockAdd,
            accessibilityIdentifier: A11y.addButton
        )
        .padding(RecipeStyles.Padding.default)
    }
}

private typealias A11y = TextBlockAddViewA11y

enum TextBlockAddViewA11y {
    static let component = "TextBlockAdd"
    static let addButton = "TextBlockAddButton"
}

#Preview {
    TextBlockAddView(onAdd: {})
}
