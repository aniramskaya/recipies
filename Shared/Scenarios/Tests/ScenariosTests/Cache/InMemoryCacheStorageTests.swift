//
//  AsyncInMemoryCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 15.06.2026.
//

import Testing
@testable import Scenarios

struct InMemoryCacheStorageTests {
    private let key1 = "key1"
    private let key2 = "key2"

    // Reading from cache before storing returns nil result
    @Test("Empty storage returns empty result")
    func emptyStorageReturnsNothing() async throws {
        let sut = makeSUT()
        
        #expect(await sut.get(key: key1) == nil)
        #expect(await sut.get(key: key2) == nil)
    }
    
    @Test("Data for distinct keys is distinct too")
    func dataIsDistinctForDistinctKeys() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
    }

    // Reading from the cache has no side effects (reading twice giving the same result)
    @Test("Reading from storage has no side effects")
    func readingHasNoSideEffects() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
    }
    
    // Storing different data under the same key replaces previous data
    @Test("Storing new data replaces previous one")
    func storingReplacesOldData() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
        
        await sut.set(key: key1, data: "value2")

        #expect(await sut.get(key: key1) == "value2")
        #expect(await sut.get(key: key2) == "value2")
    }
    
    // Clearing data for one key is removing data only for that key
    @Test("Clearing one entry doesn't touch others")
    func clearingForKeyHasNoEffectOnOtherKeys() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
        
        await sut.clear(key: key1)

        #expect(await sut.get(key: key1) == nil)
        #expect(await sut.get(key: key2) == "value2")
    }
    
    // Clearing all data removes all entries
    @Test("ClearAll removes all data")
    func clearingAllRemovesAll() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == "value1")
        #expect(await sut.get(key: key2) == "value2")
        
        await sut.clearAll()

        #expect(await sut.get(key: key1) == nil)
        #expect(await sut.get(key: key2) == nil)
    }

    private func makeSUT() -> InMemoryCacheStorage<String, String> {
        return .init()
    }
}
