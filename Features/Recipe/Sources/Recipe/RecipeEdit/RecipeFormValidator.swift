@MainActor
struct RecipeFormValidator {
    static func validate(_ model: RecipeDraftModel) -> [String: String] {
        model.ingredients.removeAll { $0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        model.steps.removeAll {
            $0.title.trimmingCharacters(in: .whitespaces).isEmpty &&
            $0.text.trimmingCharacters(in: .whitespaces).isEmpty
        }

        var errors: [String: String] = [:]

        if model.title.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["title"] = String(localized: .titleRequiredValidationError)
        }
        if model.description.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["description"] = String(localized: .descriptionRequiredValidationError)
        }
        for step in model.steps where step.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["step/\(step.id.uuidString)/text"] = String(localized: .stepTextRequiredValidationError)
        }
        if let top = model.topTextBlock, top.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["topTextBlock/text"] = String(localized: .textBlockTextRequiredValidationError)
        }
        if let bottom = model.bottomTextBlock, bottom.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["bottomTextBlock/text"] = String(localized: .textBlockTextRequiredValidationError)
        }

        return errors
    }
}
