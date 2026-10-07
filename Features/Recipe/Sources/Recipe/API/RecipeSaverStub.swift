import Foundation

public final class RecipeSaverStub: RecipeSaver {
    public init() {}
    
    public func save(_ data: RecipeData) async throws {
        try await Task.sleep(for: .milliseconds(500))
    }
}
