import Foundation

protocol RecipeLoader: AnyObject, Sendable {
    func load(id: UUID) async throws -> RecipeData
}
