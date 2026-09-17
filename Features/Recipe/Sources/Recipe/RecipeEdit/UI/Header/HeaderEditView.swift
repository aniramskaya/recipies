//
//  HeaderEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI
import RecipeUIKit

struct HeaderEditView: View {
    @Binding var value: String
    var showsError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.small) {
            TextField(String(localized: .recipeName), text: $value)
                .accessibilityIdentifier(A11y.textField)
                .padding(RecipeStyles.Padding.mulilineText)
                .background(
                    RoundedRectangle(cornerRadius: RecipeStyles.Radius.medium)
                        .fill(RecipeUIKitAssets.Color.fieldBackground)
                )
                .font(.title)
                .bold()
            if showsError {
                Text(.titleValidationError)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier(A11y.errorLabel)
            }
        }
        .padding(RecipeStyles.Padding.default)
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = HeaderEditViewA11y

enum HeaderEditViewA11y {
    static let component = "HeaderEditView"
    static let textField = "HeaderEditView.TextField"
    static let errorLabel = "HeaderEditView.ErrorLabel"
}

#Preview {
    @Previewable @State var title: String = ""
    
    HeaderEditView(value: $title)
    
    Text(title)
}
