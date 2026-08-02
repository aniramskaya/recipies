import Foundation

final class RecipeSaverStub: RecipeSaver {
    func save(_ data: RecipeData) async throws {
        try await Task.sleep(for: .milliseconds(500))
    }
}
