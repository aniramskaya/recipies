struct RecipeFormValidator {
    static func validate(_ model: Recipe) -> [String: String] {
        var errors: [String: String] = [:]

        if model.title.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["title"] = String(localized: .titleRequiredValidationError)
        }
        if (model.description ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
            errors["description"] = String(localized: .descriptionRequiredValidationError)
        }
        for step in model.steps where step.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["step/\(step.id.uuidString)/text"] = String(localized: .stepTextRequiredValidationError)
        }
        if let top = model.topText, top.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["topTextBlock/text"] = String(localized: .textBlockTextRequiredValidationError)
        }
        if let bottom = model.bottomText, bottom.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["bottomTextBlock/text"] = String(localized: .textBlockTextRequiredValidationError)
        }

        return errors
    }
}
