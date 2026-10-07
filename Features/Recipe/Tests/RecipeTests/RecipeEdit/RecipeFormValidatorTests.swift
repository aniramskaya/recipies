import Foundation
import Testing
@testable import Recipe

@MainActor
struct RecipeFormValidatorTests {

    // MARK: - Steps

    @Test func stepWithTitleButEmptyTextReturnsError() {
        let step = RecipeStep(id: UUID(), title: "Шаг 1", imageSource: nil, text: "")
        let model = makeModel(steps: [step])
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == ["step/\(step.id.uuidString)/text": String(localized: .stepTextRequiredValidationError)])
        #expect(model.steps.count == 1)
    }

    // MARK: - Text blocks

    @Test func topTextBlockWithEmptyTextReturnsError() {
        let model = makeModel(topTextBlock: TextBlock(text: "", title: "Введение"))
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == [
            "topTextBlock/text": String(localized: .textBlockTextRequiredValidationError)
        ])
    }

    @Test func bottomTextBlockWithEmptyTextReturnsError() {
        let model = makeModel(bottomTextBlock: TextBlock(text: "", title: "Заключение"))
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == [
            "bottomTextBlock/text": String(localized: .textBlockTextRequiredValidationError)
        ])
    }

    // MARK: - Title and description

    @Test func emptyTitleReturnsError() {
        let model = makeModel(title: "")
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == [
            "title": String(localized: .titleRequiredValidationError)
        ])
    }

    @Test func emptyDescriptionReturnsError() {
        let model = makeModel(description: "")
        let errors = RecipeFormValidator.validate(model)
        #expect(errors == [
            "description": String(localized: .descriptionRequiredValidationError)
        ])
    }

    // MARK: - Multiple errors

    @Test func emptyTitleAndDescriptionBothReturnErrors() {
        let model = makeModel(title: "", description: "")
        let errors = RecipeFormValidator.validate(model)
        #expect(errors["title"] != nil)
        #expect(errors["description"] != nil)
    }

    // MARK: - makeModel

    private func makeModel(
        title: String = "Рецепт",
        description: String = "Описание",
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
