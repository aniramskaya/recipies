//
//  RecipeStepEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeStepEditView: View {
    let step: UInt
    @Binding var model: RecipeStepDraftModel
    let onRemove: () -> Void

    var body: some View {
        VStack(spacing: RecipeStyles.Spacing.small) {
            RecipeStepEditHeaderView(step: step, title: $model.title)
            
            PhotoPlaceholder(onAdd: {})
            
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
                title: .cookingStepRemove,
                accessibilityIdentifier: A11y.removeButton
            )
        }
        .padding(RecipeStyles.Padding.default)
        .overlay {
            RoundedRectangle(cornerRadius: RecipeStyles.Radius.medium)
                .fill(Color.clear)
                .strokeBorder(.separator)
        }
    }
}

private typealias A11y = RecipeStepEditViewA11y

enum RecipeStepEditViewA11y {
    static let component = "RecipeStepEditView"
    static let header = "RecipeStepEditViewHeader"
    static let photoPlaceholder = "RecipeStepEditViewPhotoPlaceholder"
    static let text = "RecipeStepEditViewText"
    static let removeButton = "RecipeStepEditViewRemoveButton"
}

#Preview("Empty") {
    @Previewable @State var model = RecipeStepDraftModel(id: .init(), title: "", imageSource: nil, text: "")

    RecipeStepEditView(step: 1, model: $model) {}
}

#Preview("Filled") {
    @Previewable @State var model = RecipeStepDraftModel(id: .init(), title: "Маринование", imageSource: nil, text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час.")

    RecipeStepEditView(step: 1, model: $model) {}
}
