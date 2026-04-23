import Foundation
@testable import RecipeEdit

final class RecipeEditServer: RecipeLoader, @unchecked Sendable {
    private var continuations: [CheckedContinuation<RecipeData, Error>] = []
    private var onLoad: (() -> Void)?

    func load(id: UUID) async throws -> RecipeData {
        try await withCheckedThrowingContinuation { continuation in
            continuations.append(continuation)
            if let onLoad {
                onLoad()
                self.onLoad = nil
            }
        }
    }

    func waitForRequest(index: Int) async {
        await withCheckedContinuation { [weak self] continuation in
            self?.onLoad = { continuation.resume() }
            if self?.continuations.count ?? -1 > index {
                self?.onLoad = nil
                continuation.resume()
                return
            }
        }
    }

    func respond(with result: Result<RecipeData, Error>, at index: Int = 0) async throws {
        await waitForRequest(index: index)
        continuations[index].resume(with: result)
    }
}
