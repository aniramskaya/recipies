@MainActor
struct RecipeFormValidator {
    func validate(_ model: RecipeDraftModel) -> [RecipeFormValidationError] {
        model.ingredients.removeAll { $0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        model.steps.removeAll {
            $0.title.trimmingCharacters(in: .whitespaces).isEmpty &&
            $0.text.trimmingCharacters(in: .whitespaces).isEmpty
        }

        var errors: [RecipeFormValidationError] = []

        if model.title.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(.emptyTitle)
        }
        if model.description.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(.emptyDescription)
        }
        for step in model.steps where step.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(.emptyStepText(id: step.id))
        }
        if let top = model.topTextBlock, top.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(.emptyTopTextBlockText)
        }
        if let bottom = model.bottomTextBlock, bottom.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(.emptyBottomTextBlockText)
        }

        return errors
    }
}
