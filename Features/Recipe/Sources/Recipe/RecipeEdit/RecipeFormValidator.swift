import RecipeTypes

struct RecipeFormValidator {
    static func validate(_ model: Recipe) -> [String: String] {
        var errors: [String: String] = [:]

        if model.title.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["title"] = String(localized: .titleRequiredValidationError)
        }

        return errors
    }
}
