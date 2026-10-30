//
//  RecipeDeleterStub.swift
//  Recipe
//
//  Created by Марина Чемезова on 26.10.2026.
//
import Foundation
import Recipe
import TestHelpers

@MainActor
final class RecipeDeleterStub: RecipeDeleter, @unchecked Sendable {
    private var continuations: [CheckedContinuation<Void, Error>?] = []
    private var onDelete: (() -> Void)?
    private(set) var deletedIDs: [UUID] = []

    func delete(id: UUID) async throws {
        let index = continuations.count
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
                deletedIDs.append(id)
                if let onDelete {
                    onDelete()
                    self.onDelete = nil
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
            self?.onDelete = { continuation.resume() }
            if self?.continuations.count ?? -1 > index {
                self?.onDelete = nil
                continuation.resume()
                return
            }
        }
    }

    func respond(with result: Result<Void, Error>, at index: Int = 0) async throws {
        await waitForRequest(index: index)
        guard let cont = continuations[index] else { return }
        continuations[index] = nil
        cont.resume(with: result)
    }

    var deleteCount: Int { deletedIDs.count }
}
