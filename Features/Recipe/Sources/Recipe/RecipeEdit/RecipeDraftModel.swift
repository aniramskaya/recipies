
import SwiftUI

@MainActor
@Observable
final class RecipeDraftModel: Hashable, Identifiable, @unchecked Sendable {
    let id: UUID
    var title: String = ""
    var description: String = ""
    var ingredients: [IngredientDraftModel] = [
        .init(id: UUID(), name: ""),
    ]
    var topTextBlock: TextBlockDraftModel?
    var steps: [RecipeStepDraftModel]
    var bottomTextBlock: TextBlockDraftModel?
    
    init(
        id: UUID,
        title: String,
        description: String,
        ingredients: [IngredientDraftModel],
        topTextBlock: TextBlockDraftModel?,
        steps: [RecipeStepDraftModel],
        bottomTextBlock: TextBlockDraftModel?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.topTextBlock = topTextBlock
        self.steps = steps
        self.bottomTextBlock = bottomTextBlock
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated static func ==(lhs: RecipeDraftModel, rhs: RecipeDraftModel) -> Bool {
        lhs.id == rhs.id
    }
}


extension RecipeDraftModel {
    func toRecipeData() -> RecipeData {
        RecipeData(
            id: id,
            title: title,
            description: description,
            ingredients: ingredients.map(\.name),
            topTextBlock: topTextBlock.map { TextBlock(text: $0.text, title: $0.title.isEmpty ? nil : $0.title) },
            steps: steps.map { RecipeStep(id: $0.id, title: $0.title, imageSource: $0.imageSource, text: $0.text) },
            bottomTextBlock: bottomTextBlock.map { TextBlock(text: $0.text, title: $0.title.isEmpty ? nil : $0.title) }
        )
    }

    static var empty: RecipeDraftModel {
        .init(
            id: UUID(),
            title: "",
            description: "",
            ingredients: [
                .init(id: UUID(), name: "")
            ],
            topTextBlock: nil,
            steps: [
                .init(id: UUID(), title: "", imageSource: nil, text: "")
            ],
            bottomTextBlock: nil
        )
    }
}
