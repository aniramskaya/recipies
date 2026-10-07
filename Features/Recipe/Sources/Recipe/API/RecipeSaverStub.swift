import Foundation

public final class RecipeSaverStub: RecipeSaver {
    public init() {}
    
    public func save(_ recipe: Recipe) async throws {
        try await Task.sleep(for: .milliseconds(500))
    }
}
