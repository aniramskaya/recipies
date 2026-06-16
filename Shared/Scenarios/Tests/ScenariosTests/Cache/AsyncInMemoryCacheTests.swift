//
//  AsyncInMemoryCache.swift
//  Scenarios
//
//  Created by Марина Чемезова on 15.06.2026.
//

import Testing
@testable import Scenarios

let key1 = "key1"
let key2 = "key2"

struct AsyncInMemoryCacheTests {
    
    // Reading from cache before storing returns .empty result
    @Test("Empty cache returns empty result")
    func emptyCacheReturnsNothing() async throws {
        let sut = makeSUT()
        
        #expect(await sut.get(key: key1) == .empty)
        #expect(await sut.get(key: key2) == .empty)
    }
    
    @Test("Data for distinct keys is distinct too")
    func dataIsDistinctForDistinctKeys() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
    }

    // Reading from the cache has no side effects (reading twice giving the same result)
    @Test("Reading from cache has no side effects")
    func readingHasNoSideEffects() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
    }
    
    // Storing different data under the same key replaces previous data
    @Test("Storing new data replaces previous one")
    func storingReplacesOldData() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
        
        await sut.set(key: key1, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value2"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
    }
    
    // Clearing data for one key is removing data only for that key
    @Test("Clearing one entry doesn't touch others")
    func clearingForKeyHasNoEffectOnOtherKeys() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
        
        await sut.clear(key: key1)

        #expect(await sut.get(key: key1) == .empty)
        #expect(await sut.get(key: key2) == .fresh("value2"))
    }
    
    // Clearing all data removes all entries
    @Test("ClearAll removes all data")
    func clearingAllRemovesAll() async throws {
        let sut = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
        
        await sut.clearAll()

        #expect(await sut.get(key: key1) == .empty)
        #expect(await sut.get(key: key2) == .empty)
    }

    private func makeSUT() -> AsyncInMemoryCache<String, String> {
        return .init()
    }
}
