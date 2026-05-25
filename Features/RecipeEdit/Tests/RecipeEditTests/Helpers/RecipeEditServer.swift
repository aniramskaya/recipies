import Foundation
@testable import RecipeEdit

final class RecipeEditServer: RecipeLoader, @unchecked Sendable {
    private var continuations: [CheckedContinuation<RecipeData, Error>] = []
    private var onLoad: (() -> Void)?

    func load() async throws -> RecipeData {
        let index = continuations.count
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
                if let onLoad {
                    onLoad()
                    self.onLoad = nil
                }
            }
        } onCancel: {
            guard index < continuations.count else { return }
            continuations[index].resume(throwing: CancellationError())
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
