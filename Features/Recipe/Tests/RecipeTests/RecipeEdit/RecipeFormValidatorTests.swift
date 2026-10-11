import Foundation
import Testing
import RecipeTypes

@testable import Recipe

@MainActor
struct RecipeFormValidatorTests {

    // MARK: - Title

    @Test func emptyTitleReturnsError() {
        let model = makeModel(title: "")
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == [
            "title": String(localized: .titleRequiredValidationError)
        ])
    }

    @Test func nonEmptyTitleReturnsNoErrors() {
        let model = makeModel(title: "Рецепт")
        let errors = RecipeFormValidator.validate(model)
        #expect(errors.isEmpty)
    }

    // MARK: - makeModel

    private func makeModel(
        title: String = "Рецепт",
        description: String? = nil,
        ingredients: [Ingredient] = [],
        topTextBlock: TextBlock? = nil,
        steps: [RecipeStep] = [],
        bottomTextBlock: TextBlock? = nil
    ) -> Recipe {
        Recipe(
            id: UUID(),
            title: title,
            description: description,
            ingredients: ingredients,
            topText: topTextBlock,
            steps: steps,
            bottomText: bottomTextBlock
        )
    }
}
