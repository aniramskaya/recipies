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
        HStack {
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus.circle")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.orange)
                Text(.textBlockAdd)
                    .font(.headline)
                    .foregroundStyle(Color.orange)
            }
            .accessibilityIdentifier(A11y.addButton)
        }
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
