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
    
    var body: some View {
        HStack {
            TextField(String(localized: .recipeName), text: $value)
            .accessibilityIdentifier(A11y.textField)
            .padding(RecipeStyles.Padding.mulilineText)
            .background(
                RoundedRectangle(cornerRadius: RecipeStyles.Radius.medium)
                    .fill(RecipeUIKitAssets.Color.fieldBackground)
            )
            .font(.title)
            .bold()
        }
        .padding(
            RecipeStyles.Padding.default
        )
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = HeaderEditViewA11y

enum HeaderEditViewA11y {
    static let component = "HeaderEditView"
    static let textField = "HeaderEditView.TextField"
}

#Preview {
    @Previewable @State var title: String = ""
    
    HeaderEditView(value: $title)
    
    Text(title)
}
