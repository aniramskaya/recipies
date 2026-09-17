import Foundation
import Testing
@testable import Recipe

@MainActor
struct RecipeFormValidatorTests {

    // MARK: - Ingredients

    @Test func emptyIngredientsAreRemovedWithoutError() {
        let model = makeModel(ingredients: [
            .init(id: UUID(), name: "Мука"),
            .init(id: UUID(), name: ""),
            .init(id: UUID(), name: "Соль"),
        ])
        let errors = RecipeFormValidator().validate(model)
        #expect(errors.isEmpty)
        #expect(model.ingredients.map(\.name) == ["Мука", "Соль"])
    }

    // MARK: - Steps

    @Test func stepWithEmptyTitleAndEmptyTextIsRemoved() {
        let emptyStep = RecipeStepDraftModel(id: UUID(), title: "", imageSource: nil, text: "")
        let filledStep = RecipeStepDraftModel(id: UUID(), title: "Шаг 1", imageSource: nil, text: "Описание")
        let model = makeModel(steps: [filledStep, emptyStep])
        let errors = RecipeFormValidator().validate(model)
        #expect(errors.isEmpty)
        #expect(model.steps.map(\.id) == [filledStep.id])
    }

    @Test func stepWithTitleButEmptyTextReturnsError() {
        let step = RecipeStepDraftModel(id: UUID(), title: "Шаг 1", imageSource: nil, text: "")
        let model = makeModel(steps: [step])
        let errors = RecipeFormValidator().validate(model)
        #expect(errors == ["step/\(step.id.uuidString)/text": "stepTextValidationError"])
        #expect(model.steps.count == 1)
    }

    // MARK: - Text blocks

    @Test func topTextBlockWithEmptyTextReturnsError() {
        let model = makeModel(topTextBlock: TextBlockDraftModel(title: "Введение", text: ""))
        let errors = RecipeFormValidator().validate(model)
        #expect(errors == ["topTextBlock/text": "textBlockTextValidationError"])
    }

    @Test func bottomTextBlockWithEmptyTextReturnsError() {
        let model = makeModel(bottomTextBlock: TextBlockDraftModel(title: "Заключение", text: ""))
        let errors = RecipeFormValidator().validate(model)
        #expect(errors == ["bottomTextBlock/text": "textBlockTextValidationError"])
    }

    // MARK: - Title and description

    @Test func emptyTitleReturnsError() {
        let model = makeModel(title: "")
        let errors = RecipeFormValidator().validate(model)
        #expect(errors == ["title": "titleValidationError"])
    }

    @Test func emptyDescriptionReturnsError() {
        let model = makeModel(description: "")
        let errors = RecipeFormValidator().validate(model)
        #expect(errors == ["description": "descriptionValidationError"])
    }

    // MARK: - Multiple errors

    @Test func emptyTitleAndDescriptionBothReturnErrors() {
        let model = makeModel(title: "", description: "")
        let errors = RecipeFormValidator().validate(model)
        #expect(errors["title"] != nil)
        #expect(errors["description"] != nil)
    }

    // MARK: - makeModel

    private func makeModel(
        title: String = "Рецепт",
        description: String = "Описание",
        ingredients: [IngredientDraftModel] = [],
        topTextBlock: TextBlockDraftModel? = nil,
        steps: [RecipeStepDraftModel] = [],
        bottomTextBlock: TextBlockDraftModel? = nil
    ) -> RecipeDraftModel {
        RecipeDraftModel(
            id: UUID(),
            title: title,
            description: description,
            ingredients: ingredients,
            topTextBlock: topTextBlock,
            steps: steps,
            bottomTextBlock: bottomTextBlock
        )
    }
}
