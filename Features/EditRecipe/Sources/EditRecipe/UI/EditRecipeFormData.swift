struct EditRecipeFormData {
    let name: String
    let cookingTime: String
    let complexity: Int

    static let empty = EditRecipeFormData(name: "", cookingTime: "", complexity: 1)
}

struct EditRecipeFormErrors {
    let name: String?
    let cookingTime: String?
    let complexity: String?

    static let none = EditRecipeFormErrors(name: nil, cookingTime: nil, complexity: nil)
}
