//
//  IntLoaderSpy.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

class IntLoaderSpy: @unchecked Sendable {
    private var continuations: [CheckedContinuation<Int, Error>?] = []
    private var onLoad: (() -> Void)?
    private(set) var loadCallCount: Int = 0
    
    func load() async throws -> Int {
        let index = continuations.count
        loadCallCount += 1
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
                if let onLoad {
                    onLoad()
                    self.onLoad = nil
                }
            }
        } onCancel: {
            // onCancel вызывается с произвольного потока — диспатчим на MainActor,
            // где continuation гарантированно уже добавлен в массив.
            Task { @MainActor [weak self] in
                guard let self,
                      index < self.continuations.count,
                      let continuation = continuations[index]
                else {
                    print("no item at \(index)")
                    return
                }
                print("cancelling item at \(index)")
                continuation.resume(throwing: CancellationError())
                continuations[index] = nil
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
    
    func respond(with result: Result<Int, Error>, at index: Int = 0) async throws {
        await waitForRequest(index: index)
        guard let continuation = continuations[index] else { return }
        continuation.resume(with: result)
        continuations[index] = nil
    }
    
    deinit {
        print("IntLoaderSpy deinit")
    }
}
