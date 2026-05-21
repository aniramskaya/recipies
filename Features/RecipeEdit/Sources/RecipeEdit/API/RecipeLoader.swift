import Foundation

protocol RecipeLoader: AnyObject, Sendable {
    func load() async throws -> RecipeData
}
