//
//  BasicLoadingScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//


import Foundation

public actor BasicLoadingScenario<Data: Sendable>: Scenario {
    private let stream: CurrentValueStream<State>
    private let load: @Sendable () async throws -> Resource
    
    public init(loader: @escaping @Sendable () async throws -> Resource) {
        self.load = loader
        stream = CurrentValueStream(.idle)
    }
    
    // MARK: LoadingScenario
    public typealias Resource = Data
    public typealias State = LoadingScenarioState<Resource>
    
    public func statesStream() async -> AsyncStream<State> {
        await stream.makeStream()
    }

    public func start() async {
        await stream.yield(.loading)

        guard !Task.isCancelled else {
            await stream.yield(.idle)
            return
        }

        do {
            let data = try await load()
            guard !Task.isCancelled else {
                await stream.yield(.idle)
                return
            }
            await stream.yield(.success(data))
            await stream.yield(.finished)
        } catch {
            guard !Task.isCancelled else {
                await stream.yield(.idle)
                return
            }
            await stream.yield(.failure(error))
        }
    }
    
    internal func finish() async {
        await stream.finish()
    }
        
    deinit {
        print("Loading scenario deinited")
    }
}
