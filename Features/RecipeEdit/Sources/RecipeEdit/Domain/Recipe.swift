import Foundation

struct Recipe: Sendable, Identifiable {
    let id: UUID
    let imageSource: URL
    let cookingTimeMins: Int
    let complexity: Int
    let title: String
    let description: String?
    let ingredients: [Ingredient]
    let topText: TextBlock?
    let steps: [RecipeStep]
    let bottomText: TextBlock?
}

struct Ingredient: Sendable {
    let isOn: Bool
    let name: String
}

struct RecipeStep: Sendable {
    let step: UInt
    let title: String
    let imageSource: URL?
    let text: String
}

struct TextBlock: Identifiable, Sendable {
    let id: UUID
    let text: String
    let title: String?
}
