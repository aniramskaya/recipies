//
//  RecipeListRow.swift
//  RecipieList
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI
import RecipeUIKit

struct RecipeListRowModel: Identifiable {
    let id: UUID
    let name: String
    let imageSource: RecipeImageSource
    let cookingTimeMins: Int
    let rating: Float
}

struct RecipeListRow: View {
    let model: RecipeListRowModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RecipeImageView(source: model.imageSource)
                .frame(height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4, x: 1, y: 2)
            Text(model.name)
                .font(Font.title2)
                .bold()
                .accessibilityIdentifier(A11y.name)
            HStack {
                CookingTimeView(minutes: model.cookingTimeMins)
                    .accessibilityIdentifier(A11y.cookingTime)
                Spacer()
                RatingView(value: model.rating)
                    .accessibilityIdentifier(A11y.rating)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .accessibilityIdentifier(A11y.component)
    }
}

public enum RecipeListRowA11y {
    static let component = "RecipeListRow"
    static let name = "RecipeName"
    static let cookingTime = "CookingTime"
    static let rating = "Rating"
}

private typealias A11y = RecipeListRowA11y

#Preview {
    RecipeListRow(
        model: .init(
            id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
            name: "Котлета по-киевски",
            imageSource: .uiImage(RecipeListUIAssets.image(named: "kiev")!),
            cookingTimeMins: 35,
            rating: 4.6
        )
    )
}
