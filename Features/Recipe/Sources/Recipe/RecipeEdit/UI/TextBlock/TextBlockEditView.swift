//
//  TextBlock.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI
import RecipeUIKit

struct TextBlockEditView: View {
    @Binding var model: TextBlockDraftModel
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: RecipeStyles.Spacing.small) {
            TextField(String(localized: .textBlockTitle), text: $model.title)
                .font(.title2).bold()
                .accessibilityIdentifier(A11y.title)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
            TextField(String(localized: .textBlockText), text: $model.text, axis: .vertical)
                .accessibilityIdentifier(A11y.text)
                .padding(12)
                .background(
                    RoundedRectangle(
                        cornerRadius: RecipeStyles.Radius.medium
                    )
                    .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
            
            HStack {
                Spacer()
                Button(action: onRemove) {
                    Image(systemName: "minus.circle")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.red)
                    Text(.textBlockRemove)
                        .font(.headline)
                        .foregroundStyle(Color.red)
                }
                .accessibilityIdentifier(A11y.removeButton)
            }
        }
        .padding(RecipeStyles.Padding.default)
    }
}

private typealias A11y = TextBlockEditViewA11y

enum TextBlockEditViewA11y {
    static let component = "TextBlock"
    static let title = "TextBlockTitle"
    static let text = "TextBlockText"
    static let removeButton = "TextBlockRemoveButton"
}

#Preview("Filled") {
    @Previewable @State var model = TextBlockDraftModel(title: "Title", text: "Text")

    TextBlockEditView(model: $model, onRemove: {})
}

#Preview("Empty") {
    @Previewable @State var model = TextBlockDraftModel(title: "", text: "")

    TextBlockEditView(model: $model, onRemove: {})
}
