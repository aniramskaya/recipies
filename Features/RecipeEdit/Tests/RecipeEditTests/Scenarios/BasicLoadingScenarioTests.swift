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
            for await state in sut.states {
                states.append(state)
            }
        }
        
        await sut.start()
        sut.finish()
        
        await collectTask.value
        
        #expect(states.count == 2)
        #expect(states[0] == .loading)
    }
}
