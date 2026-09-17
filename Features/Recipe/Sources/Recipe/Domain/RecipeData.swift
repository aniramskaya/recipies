import Foundation

struct RecipeData: Sendable {
    let id: UUID
    let title: String
    let description: String
    let ingredients: [String]
    let topTextBlock: TextBlock?
    let steps: [RecipeStep]
    let bottomTextBlock: TextBlock?
}
