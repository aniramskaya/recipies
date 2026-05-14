//
//  BasicLoadingScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//


import Foundation

public final class BasicLoadingScenario<Data: Sendable>: Sendable {
    private let continuation: AsyncStream<LoadingScenarioState<Resource>>.Continuation
    
    private let load: @Sendable () async throws -> Resource
    
    public init(loader: @escaping @Sendable () async throws -> Resource) {
        self.load = loader
        (states, continuation) = AsyncStream.makeStream(
            of: LoadingScenarioState<Resource>.self,
            bufferingPolicy: .bufferingNewest(1)
        )
    }
    
    // MARK: LoadingScenario
    public typealias Resource = Data
    
    public let states: AsyncStream<LoadingScenarioState<Resource>>

    public func start() async {
        continuation.yield(.loading)

        guard !Task.isCancelled else {
            continuation.yield(.idle)
            return
        }

        do {
            let data = try await load()
            guard !Task.isCancelled else {
                continuation.yield(.idle)
                return
            }
            continuation.yield(.success(data))
        } catch {
            guard !Task.isCancelled else {
                continuation.yield(.idle)
                return
            }
            continuation.yield(.failure(error))
        }
    }
    
    internal func finish() {
        continuation.finish()
    }
}
