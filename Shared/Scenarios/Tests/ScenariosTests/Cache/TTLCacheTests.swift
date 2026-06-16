//
//  TTLCacheTests.swift
//  Scenarios
//
//  Created by Марина Чемезова on 16.06.2026.
//

import Foundation
import Testing
@testable import Scenarios

struct TTLCacheTests {
    private let key1 = "key1"
    private let key2 = "key2"

    // Reading from cache before storing returns nil result
    @Test("Empty cache returns empty result")
    func emptyStorageReturnsNothing() async throws {
        let (sut, _) = makeSUT()
        
        #expect(await sut.get(key: key1) == .empty)
        #expect(await sut.get(key: key2) == .empty)
    }
    
    @Test("Data for distinct keys is distinct too")
    func dataIsDistinctForDistinctKeys() async throws {
        let (sut, _) = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
    }
    
    @Test("Data is stale according to policy")
    func dataIsStaleWhenPolicyReturnsStale() async throws {
        let (sut, policy) = makeSUT()
        policy.stubValid = false
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .stale("value1"))
        #expect(await sut.get(key: key2) == .stale("value2"))
    }

    // Reading from the cache has no side effects (reading twice giving the same result)
    @Test("Reading from storage has no side effects")
    func readingHasNoSideEffects() async throws {
        let (sut, _) = makeSUT()
        
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
        let (sut, _) = makeSUT()
        
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
        let (sut, _) = makeSUT()
        
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
        let (sut, _) = makeSUT()
        
        await sut.set(key: key1, data: "value1")
        await sut.set(key: key2, data: "value2")

        #expect(await sut.get(key: key1) == .fresh("value1"))
        #expect(await sut.get(key: key2) == .fresh("value2"))
        
        await sut.clearAll()

        #expect(await sut.get(key: key1) == .empty)
        #expect(await sut.get(key: key2) == .empty)
    }

    private func makeSUT() -> (TTLCache<InMemoryCacheStorage<String, String>>, TTLPolicyStub) {
        let policy = TTLPolicyStub()
        let storage = InMemoryCacheStorage<String, String>()
        return (TTLCache(storage: storage, expirationPolicy: policy), policy)
    }
}

private final class TTLPolicyStub: TTLPolicy, @unchecked Sendable {
    var stubValid = true

    func isValid(savedAt: Date) -> Bool {
        stubValid
    }
}
