
import SwiftUI

@MainActor
@Observable
final class RecipeDraftModel: Hashable, Identifiable, @unchecked Sendable {
    let id: UUID
    var imageSource: URL?
    var cookingTimeMins: Int
    var complexity: Int
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
        imageSource: URL? = nil,
        cookingTimeMins: Int = 0,
        complexity: Int = 0,
        title: String,
        description: String,
        ingredients: [IngredientDraftModel],
        topTextBlock: TextBlockDraftModel?,
        steps: [RecipeStepDraftModel],
        bottomTextBlock: TextBlockDraftModel?
    ) {
        self.id = id
        self.imageSource = imageSource
        self.cookingTimeMins = cookingTimeMins
        self.complexity = complexity
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
    func toRecipe() -> Recipe {
        Recipe(
            id: id,
            imageSource: imageSource,
            cookingTimeMins: cookingTimeMins,
            complexity: complexity,
            title: title,
            description: description.isEmpty ? nil : description,
            ingredients: ingredients
                .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
                .map { Ingredient(id: $0.id, name: $0.name) },
            topText: topTextBlock.map { TextBlock(text: $0.text, title: $0.title.isEmpty ? nil : $0.title) },
            steps: steps
                .filter{ !(
                        $0.text.trimmingCharacters(in: .whitespaces).isEmpty &&
                        $0.title.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
                .map {
                    RecipeStep(id: $0.id, title: $0.title.isEmpty ? nil : $0.title, imageSource: $0.imageSource, text: $0.text)
                },
            bottomText: bottomTextBlock.map { TextBlock(text: $0.text, title: $0.title.isEmpty ? nil : $0.title) }
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
