//
//  RecipeListRow.swift
//  RecipeList
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
    let complexity: Int
    let isDraft: Bool
}

struct RecipeListRow: View {
    let model: RecipeListRowModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RecipeImageView(source: model.imageSource)
                .frame(height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4, x: 1, y: 2)
                .overlay(alignment: .topLeading) {
                    if model.isDraft {
                        DraftBadgeView()
                            .padding(10)
                    }
                }
            Text(model.name)
                .font(Font.title2)
                .bold()
                .accessibilityIdentifier(A11y.name)
            HStack {
                CookingTimeView(minutes: model.cookingTimeMins)
                    .accessibilityIdentifier(A11y.cookingTime)
                Spacer()
                RecipeComplexityView(value: model.complexity)
                    .accessibilityIdentifier(A11y.complexity)
                    .frame(width: 44, height: 18)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .accessibilityIdentifier(A11y.component)
    }
}

private struct DraftBadgeView: View {
    var body: some View {
        Text("Черновик")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
    }
}

enum RecipeListRowA11y {
    static let component = "RecipeListRow"
    static let name = "RecipeName"
    static let cookingTime = "CookingTime"
    static let complexity = "Complexity"
}

private typealias A11y = RecipeListRowA11y

#Preview {
    VStack {
        RecipeListRow(
            model: .init(
                id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cf")!,
                name: "Котлета по-киевски",
                imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
                cookingTimeMins: 35,
                complexity: 3,
                isDraft: false
            )
        )
        RecipeListRow(
            model: .init(
                id: UUID(uuidString: "b0a1a334-09b3-4e61-87bf-0b05745388cd")!,
                name: "Новый · 13 окт",
                imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
                cookingTimeMins: 0,
                complexity: 0,
                isDraft: true
            )
        )
    }
}
