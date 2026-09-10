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
                .padding(RecipeStyles.Padding.singleLineText)
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
            TextField(String(localized: .textBlockText), text: $model.text, axis: .vertical)
                .accessibilityIdentifier(A11y.text)
                .padding(RecipeStyles.Padding.mulilineText)
                .background(
                    RoundedRectangle(
                        cornerRadius: RecipeStyles.Radius.medium
                    )
                    .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
            
            RemoveElementButton(
                action: onRemove,
                title: .textBlockRemove,
                accessibilityIdentifier: A11y.removeButton
            )
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
