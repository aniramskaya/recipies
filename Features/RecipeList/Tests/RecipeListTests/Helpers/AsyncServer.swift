//
//  AsyncServer.swift
//  RecipeListTests
//

import RecipeList

final class AsyncServer: RecipeListLoader, @unchecked Sendable {
    var continuations: [CheckedContinuation<[RecipeListItem], Error>] = []
    private var onLoad: (() -> Void)?

    func load() async throws -> [RecipeListItem] {
        return try await withCheckedThrowingContinuation { continuation in
            continuations.append(continuation)
            if let onLoad {
                onLoad()
                self.onLoad = nil
            }
        }
    }

    func waitForRequest(index: Int) async {
        await withCheckedContinuation { [weak self] continuation in
            self?.onLoad = {
                continuation.resume()
            }
            if self?.continuations.count ?? -1 > index {
                self?.onLoad = nil
                continuation.resume()
                return
            }
        }
    }

    func respond(with result: Result<[RecipeListItem], Error>, at index: Int? = nil) async throws {
        await waitForRequest(index: index ?? 0)
        continuations[index ?? 0].resume(with: result)
    }
}
