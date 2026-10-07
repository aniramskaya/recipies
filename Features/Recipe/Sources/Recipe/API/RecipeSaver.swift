import Foundation

public protocol RecipeSaver: AnyObject, Sendable {
    func save(_ data: RecipeData) async throws
}
