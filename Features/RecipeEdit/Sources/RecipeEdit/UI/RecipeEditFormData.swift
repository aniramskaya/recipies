struct RecipeEditFormData {
    let name: String
    let cookingTime: String
    let complexity: Int

    static let empty = RecipeEditFormData(name: "", cookingTime: "", complexity: 1)
}

struct RecipeEditFormErrors {
    let name: String?
    let cookingTime: String?
    let complexity: String?

    static let none = RecipeEditFormErrors(name: nil, cookingTime: nil, complexity: nil)
}
