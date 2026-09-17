@MainActor
struct RecipeFormValidator {
    func validate(_ model: RecipeDraftModel) -> [String: String] {
        model.ingredients.removeAll { $0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        model.steps.removeAll {
            $0.title.trimmingCharacters(in: .whitespaces).isEmpty &&
            $0.text.trimmingCharacters(in: .whitespaces).isEmpty
        }

        var errors: [String: String] = [:]

        if model.title.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["title"] = ""
        }
        if model.description.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["description"] = ""
        }
        for step in model.steps where step.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["step/\(step.id.uuidString)/text"] = ""
        }
        if let top = model.topTextBlock, top.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["topTextBlock/text"] = ""
        }
        if let bottom = model.bottomTextBlock, bottom.text.trimmingCharacters(in: .whitespaces).isEmpty {
            errors["bottomTextBlock/text"] = ""
        }

        return errors
    }
}
