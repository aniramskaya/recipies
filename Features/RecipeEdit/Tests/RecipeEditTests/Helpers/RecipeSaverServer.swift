import Foundation
@testable import RecipeEdit

final class RecipeSaverServer: RecipeSaver, @unchecked Sendable {
    private var continuations: [CheckedContinuation<Void, Error>] = []
    private var onSave: (() -> Void)?

    func save(_ data: RecipeData) async throws {
        let index = continuations.count
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
                if let onSave {
                    onSave()
                    self.onSave = nil
                }
            }
        } onCancel: {
            guard index < continuations.count else { return }
            continuations[index].resume(throwing: CancellationError())
        }
    }

    func waitForRequest(index: Int) async {
        await withCheckedContinuation { [weak self] continuation in
            self?.onSave = { continuation.resume() }
            if self?.continuations.count ?? -1 > index {
                self?.onSave = nil
                continuation.resume()
                return
            }
        }
    }

    func respond(with result: Result<Void, Error>, at index: Int = 0) async throws {
        await waitForRequest(index: index)
        continuations[index].resume(with: result)
    }
}
