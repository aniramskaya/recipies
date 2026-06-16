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

enum LoadingError: Error, Equatable {
    case undefined
}

class IntLoaderSpy: @unchecked Sendable {
    private var continuations: [CheckedContinuation<Int, Error>?] = []
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
