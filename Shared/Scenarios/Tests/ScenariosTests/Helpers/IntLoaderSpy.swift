//
//  IntLoaderSpy.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//
import TestHelpers
import Testing

class IntLoaderSpy: @unchecked Sendable {
    private var continuations: [CheckedContinuation<Int, Error>?] = []
    private(set) var loadCallCount: Int = 0
    
    func load() async throws -> Int {
        let index = continuations.count
        loadCallCount += 1
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
            }
        } onCancel: {
            // onCancel вызывается с произвольного потока — диспатчим на MainActor,
            // где continuation гарантированно уже добавлен в массив.
            Task { @MainActor [weak self] in
                guard let self,
                      index < self.continuations.count,
                      let continuation = continuations[index]
                else {
                    return
                }
                continuation.resume(throwing: CancellationError())
                continuations[index] = nil
            }
        }
    }
    
    func respond(with result: Result<Int, Error>, at index: Int = 0, sourceLocation: SourceLocation = #_sourceLocation) async throws {
        await waitFor(sourceLocation: sourceLocation) { [weak self] in
            guard let self else { return true }
            if index < continuations.count {
                return true
            }
            throw TestError(reason: "IntLoaderSpy.load has not been called for resume at index \(index)")
        }
//        #expect(index < continuations.count, "IntLoaderSpy.load has not been called for resume at index \(index)", sourceLocation: sourceLocation)
        guard index < continuations.count, let continuation = continuations[index] else { return }
        continuation.resume(with: result)
        continuations[index] = nil
    }
}
