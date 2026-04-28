struct RecipeEditFormErrors {
    let name: String?
    let cookingTime: String?
    let complexity: String?

    static let none = RecipeEditFormErrors(name: nil, cookingTime: nil, complexity: nil)
}
