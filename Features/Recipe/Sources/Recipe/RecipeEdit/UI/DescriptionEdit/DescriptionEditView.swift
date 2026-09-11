//
//  DescriptionEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 09.08.2026.
//

import SwiftUI
import RecipeUIKit

struct DescriptionEditView: View {
    @Binding var text: String
    
    var body: some View {
        TextField(String(localized: .recipeDescription), text: $text, axis: .vertical)
            .accessibilityIdentifier(A11y.field)
            .padding(RecipeStyles.Padding.mulilineText)
            .background(
                RoundedRectangle(
                    cornerRadius: RecipeStyles.Radius.medium
                )
                .fill(RecipeUIKitAssets.Color.fieldBackground)
            )
            .padding(RecipeStyles.Padding.default)
    }
}

private typealias A11y = DescriptionEditViewA11y

enum DescriptionEditViewA11y {
    static let field = "DescriptionEditViewField"
}

#Preview {
    @Previewable @State var text: String = "Нежные кусочки маринованной курицы, обжаренные на сильном огне, томятся в насыщенном соусе из спелых томатов, сливок и ароматных специй — гарам масала, имбиря, кориандра. Одно из самых знаменитых блюд индийской кухни, покорившее весь мир своим глубоким, бархатным вкусом."
    
    DescriptionEditView(text: $text)
}
