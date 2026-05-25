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
        var states: [LoadingScenarioState<Int>] = []
        
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
        var states: [LoadingScenarioState<Int>] = []

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
        var states: [LoadingScenarioState<Int>] = []
        
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
        
        collectTask.cancel()
        await collectTask.value
        await Task.yield()
    }
}

extension LoadingScenarioState: Equatable where Resource: Equatable {
    public static func == (lhs: LoadingScenarioState<Resource>, rhs: LoadingScenarioState<Resource>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.failure, .failure): return true
        case let (.loaded(lv), .loaded(rv)): return lv == rv
        default: return false
        }
    }
}

enum LoadingError: Error, Equatable {
    case undefined
}

class IntLoaderSpy: @unchecked Sendable {
    private var continuations: [CheckedContinuation<Int, Error>] = []
    private var onLoad: (() -> Void)?
    
    func load() async throws -> Int {
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
            continuations.remove(at: index)
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
        continuations[index].resume(with: result)
    }
}
