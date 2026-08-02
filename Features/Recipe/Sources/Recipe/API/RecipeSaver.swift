import Foundation

protocol RecipeSaver: AnyObject, Sendable {
    func save(_ data: RecipeData) async throws
}
