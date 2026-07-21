//
//  RecipeDescriptionView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI

struct RecipeDescriptionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(description)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier(A11y.description)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = RecipeDescriptionViewA11y

enum RecipeDescriptionViewA11y {
    static let component = "RecipeDescriptionView"
    static let description = "RecipeDescriptionValue"
}

#Preview {
    VStack {
        RecipeDescriptionView(description: "Нежные кусочки")
        RecipeDescriptionView(description: "Нежные кусочки маринованной курицы, обжаренные на сильном огне, томятся в насыщенном соусе из спелых томатов, сливок и ароматных специй — гарам масала, имбиря, кориандра. Одно из самых знаменитых блюд индийской кухни, покорившее весь мир своим глубоким, бархатным вкусом.")
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.init(top: 100, leading: 0, bottom: 0, trailing: 0))
}
