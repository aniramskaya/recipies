import Foundation

final class RecipeSaverStub: RecipeSaver, @unchecked Sendable {
    func save(_ data: RecipeData) async throws {}
}
