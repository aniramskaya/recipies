//
//  BasicLoadingScenarioTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.05.2026.
//

@testable import Scenarios
import Foundation
import Testing
import TestHelpers

@MainActor
struct BasicLoadingScenarioTests {
    let leakChecker = LeakChecker()

    @Test func failureEmitsError() async throws {
        var states: [BasicLoadingScenario<Int>.State] = []
        
        let loader = IntLoaderSpy()
        let sut = BasicLoadingScenario<Int>(loader: { try await loader.load() })
        
        leakChecker.track(sut)
        leakChecker.track(loader)
        
        let started = AsyncStream<Void>.makeStream()

        let collectTask = Task {
            let stream = sut.start()
            started.continuation.yield(())
            for await state in stream {
                states.append(state)
            }
        }

        for await _ in started.stream {
            break
        }
        
        let error = NSError.any()
        try await loader.respond(with: .failure(error))

        await collectTask.value

        #expect(states.count == 2)
        #expect(states == [.loading, .failure(error)])
        await Task.yield()    }
    
    @Test func loadingEmitsSuccess() async throws {
        var states: [BasicLoadingScenario<Int>.State] = []

        let loader = IntLoaderSpy()
        let sut = BasicLoadingScenario<Int>(loader: { try await loader.load() })

        leakChecker.track(sut)
        leakChecker.track(loader)

        let started = AsyncStream<Void>.makeStream()

        let collectTask = Task {
            let stream = sut.start()
            started.continuation.yield(())
            for await state in stream {
                states.append(state)
            }
        }

        for await _ in started.stream {
            break
        }
        
        try await loader.respond(with: .success(42))

        await collectTask.value

        #expect(states.count == 2)
        #expect(states == [.loading, .loaded(42)])
        await Task.yield()
    }
    
    @Test func cancelDontCausesLeaks() async throws {
        do {
            var states: [BasicLoadingScenario<Int>.State] = []
            
            let loader = IntLoaderSpy()
            let sut = BasicLoadingScenario<Int>(loader: loader.load)
            
            leakChecker.track(sut)
            leakChecker.track(loader)
            
            let started = AsyncStream<Void>.makeStream()
            
            let collectTask = Task {
                let stream = sut.start()
                started.continuation.yield(())
                for await state in stream {
                    states.append(state)
                }
            }
            
            for await _ in started.stream {
                break
            }
            
            collectTask.cancel()
            await collectTask.value
        }
        await leakChecker.awaitAllReleased()
    }
}

extension BasicLoadingScenario.State: Equatable where Data: Equatable {
    public static func == (lhs: BasicLoadingScenario<Data>.State, rhs: BasicLoadingScenario<Data>.State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.failure, .failure): return true
        case let (.loaded(lv), .loaded(rv)): return lv == rv
        default: return false
        }
    }
}
