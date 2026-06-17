//
//  CachingLoadingScenarioTests.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

@testable import Scenarios
import Foundation
import Testing
import TestHelpers

/*
 Что тестим
 
 Кэша нет
    Ошибка загрузки возвращает ошибку
    Успешная загрузка возвращает данные
 Кэш есть и он свежий
    Возврат данных из кэша
 Кэш есть и он протух
    Возврат данных из кэша, затем загрузка
        Успех - возвращаются обновленные данные
        Ошибка - возвращаются старые данные
 
 Эксплицитная загрузка по требованию
     Возврат данных из кэша, затем загрузка
         Успех - возвращаются обновленные данные
         Ошибка - возвращаются старые данные

 */

@MainActor
private func makeSUT(leakChecker: LeakChecker, sourceLocation: SourceLocation = #_sourceLocation) -> (CachingLoadingScenario<Int>, IntLoaderSpy, SingleValueCacheStub<Int>) {
    let cache = SingleValueCacheStub<Int>()
    let loader = IntLoaderSpy()
    let sut = CachingLoadingScenario<Int>(cache: cache, loader: loader.load)
    
    leakChecker.track([sut, loader, cache])
    
    return (sut, loader, cache)
}

@Suite("CachingLoadingScenario")
struct CachingLoadingScenarioTests {

    @Suite("No cached data")
    @MainActor
    struct NoCachedData {
        let leakChecker = LeakChecker()

        @Test
        func failureReturnsError() async throws {
            let (sut, loader, _) = makeSUT(leakChecker: leakChecker)
            let error = NSError.any()

            let states = try await collectStates(from: sut) {
                try await loader.respond(with: .failure(error))
            }

            #expect(loader.loadCallCount == 1)
            #expect(states.count == 2)
            #expect(states == [
                .init(isLoading: true, data: nil, error: nil),
                .init(isLoading: false, data: nil, error: error)
            ])
        }

        @Test
        func successReturnsData() async throws {
            let (sut, loader, _) = makeSUT(leakChecker: leakChecker)

            let states = try await collectStates(from: sut) {
                try await loader.respond(with: .success(42))
            }

            #expect(loader.loadCallCount == 1)
            #expect(states.count == 2)
            #expect(states == [
                .init(isLoading: true, data: nil, error: nil),
                .init(isLoading: false, data: 42, error: nil)
            ])
        }
    }
    
    @Suite("Valid cached data")
    @MainActor
    struct ValidCachedData {
        let leakChecker = LeakChecker()

        @Test
        func returnsCachedData() async throws {
            let (sut, loader, cache) = makeSUT(leakChecker: leakChecker)
            
            await cache.set(data: 42)

            let states = try await collectStates(from: sut) { }

            #expect(loader.loadCallCount == 0)
            #expect(states.count == 1)
            #expect(states == [
                .init(isLoading: false, data: 42, error: nil)
            ])
        }
    }
    
    @Suite("Stale cached data")
    @MainActor
    struct StaleCachedData {
        let leakChecker = LeakChecker()

        @Test
        func failureReturnsCachedDataAndError() async throws {
            let (sut, loader, cache) = makeSUT(leakChecker: leakChecker)
            let error = NSError.any()

            await cache.set(data: 42)
            await cache.setIsValid(false)
            
            let states = try await collectStates(from: sut) {
                try await loader.respond(with: .failure(error))
            }

            #expect(loader.loadCallCount == 1)
            #expect(states.count == 2)
            #expect(states == [
                .init(isLoading: true, data: 42, error: nil),
                .init(isLoading: false, data: 42, error: error)
            ])
        }

        @Test
        func successReturnsUpdatedData() async throws {
            let (sut, loader, cache) = makeSUT(leakChecker: leakChecker)

            await cache.set(data: 42)
            await cache.setIsValid(false)

            let states = try await collectStates(from: sut) {
                try await loader.respond(with: .success(53))
            }

            #expect(loader.loadCallCount == 1)
            #expect(states.count == 2)
            #expect(states == [
                .init(isLoading: true, data: 42, error: nil),
                .init(isLoading: false, data: 53, error: nil)
            ])
        }
    }
}

@MainActor
private func collectStates(
    from sut: CachingLoadingScenario<Int>,
    during action: () async throws -> Void
) async throws -> [CachingLoadingScenario<Int>.State] {
    var states: [CachingLoadingScenario<Int>.State] = []
    let started = AsyncStream<Void>.makeStream()

    let collectTask = Task {
        let stream = sut.load()
        started.continuation.yield(())
        for await state in stream {
            states.append(state)
        }
    }

    for await _ in started.stream { break }
    try await action()
    await collectTask.value

    return states
}

extension CachingLoadingScenario.State: Equatable where Data: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isLoading == rhs.isLoading
            && lhs.data == rhs.data
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
    }
}
