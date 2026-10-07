import Foundation
import RecipeTypes

public protocol RecipeSaver: AnyObject, Sendable {
    func save(_ recipe: Recipe) async throws
}
