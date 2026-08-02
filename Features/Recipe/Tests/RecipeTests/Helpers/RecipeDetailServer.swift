import Foundation
@testable import Recipe

@MainActor
final class RecipeDetailServer: RecipeDetailLoader {
    private var continuations: [CheckedContinuation<Recipe, Error>?] = []
    private var onLoad: (() -> Void)?

    func load() async throws -> Recipe {
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
            Task { @MainActor [weak self] in
                guard let self,
                      index < self.continuations.count,
                      let cont = self.continuations[index] else { return }
                self.continuations[index] = nil
                cont.resume(throwing: CancellationError())
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

    func respond(with result: Result<Recipe, Error>, at index: Int = 0) async throws {
        await waitForRequest(index: index)
        guard let cont = continuations[index] else { return }
        continuations[index] = nil
        cont.resume(with: result)
    }
}
