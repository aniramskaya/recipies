import Foundation

public protocol RecipeSaver: AnyObject, Sendable {
    func save(_ recipe: Recipe) async throws
}
