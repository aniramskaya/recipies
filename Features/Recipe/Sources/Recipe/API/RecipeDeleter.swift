import Foundation

public protocol RecipeDeleter: AnyObject, Sendable {
    func delete(id: UUID) async throws
}
