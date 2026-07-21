//
//  RecipeTitleView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import SwiftUI

struct RecipeTitleView: View {
    let title: String
    
    var body: some View {
        HStack{
            Text(title)
                .font(.title)
                .bold()
                .accessibilityIdentifier(RecipeTitleViewA11y.component)
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.init(top: 16, leading: 20, bottom: 12, trailing: 20))
    }
}

enum RecipeTitleViewA11y {
    static let component = "RecipeDescriptionTitle"
}

#Preview {
    RecipeTitleView(title: "Tikka Masala")
}
