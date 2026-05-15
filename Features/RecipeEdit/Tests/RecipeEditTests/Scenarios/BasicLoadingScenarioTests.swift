//
//  BasicLoadingScenarioTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.05.2026.
//

@testable import RecipeEdit
import Testing

extension LoadingScenarioState: Equatable where Resource: Equatable {
    public static func == (lhs: RecipeEdit.LoadingScenarioState<Resource>, rhs: RecipeEdit.LoadingScenarioState<Resource>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.failure, .failure): return true
        case let (.success(lv), .success(rv)): return lv == rv
        default: return false
        }
    }
}

enum LoadingError: Error, Equatable {
    case undefined
}

@MainActor
struct BasicLoadingScenarioTests {
    @Test func failureEmitsError() async throws {
        var states: [LoadingScenarioState<Int>] = []
        
        let sut = BasicLoadingScenario<Int> {
            throw LoadingError.undefined
        }
        
        let collectTask = Task {
            for await state in sut.futureStates {
                states.append(state)
            }
        }
        
        states.append(await sut.currentState())

        await sut.start()
        await sut.finish()
        
        await collectTask.value
        
        #expect(states.count == 3)
        #expect(states == [.idle, .loading, .failure(LoadingError.undefined)])
    }
    
    @Test func loadingEmitsSuccess() async throws {
        var states: [LoadingScenarioState<Int>] = []
        
        let sut = BasicLoadingScenario<Int> {
            return 42
        }
        
        let collectTask = Task {
            for await state in sut.futureStates {
                states.append(state)
            }
        }
        
        states.append(await sut.currentState())

        await sut.start()
        await sut.finish()
        
        await collectTask.value
        
        #expect(states.count == 3)
        #expect(states == [.idle, .loading, .success(42)])
    }
}
