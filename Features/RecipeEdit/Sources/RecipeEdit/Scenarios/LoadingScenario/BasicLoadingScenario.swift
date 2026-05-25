//
//  BasicLoadingScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//


import Foundation

public final class BasicLoadingScenario<Data: Sendable>: Sendable {
    private let load: @Sendable () async throws -> Data
    
    public init(loader: @escaping @Sendable () async throws -> Data) {
        self.load = loader
    }
    
    // MARK: LoadingScenario

    public func start() -> AsyncStream<LoadingScenarioState<Data>> {
        let (stream, continuation) = AsyncStream.makeStream(
            of: LoadingScenarioState<Data>.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let load = self.load
        let task = Task {
            continuation.yield(.loading)

            guard !Task.isCancelled else { continuation.finish(); return }

            do {
                let data = try await load()
                guard !Task.isCancelled else { continuation.finish(); return }
                continuation.yield(.loaded(data))
                continuation.finish()
            } catch {
                guard !Task.isCancelled else { continuation.finish(); return }
                continuation.yield(.failure(error))
                continuation.finish()
            }
        }
        continuation.onTermination = { _ in
            task.cancel()
        }
        return stream
    }
}
