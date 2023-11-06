//
//  RecipieListCache.swift
//  RecipieList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation
import XCTest
@testable import RecipieList

/*
 ✅ При инициализации кэш пуст
 ✅ До истечения времени жизни кэша он возвращает данные
 ✅ После истечения времени жизни кэша он возвращает ошибку
 */
/*
 Cache is empty upon initialization
 Cache returns data when timestamp is not expired
 Cache returns error when timestamp is expired
 */

struct RecipeListStored {
    let items: [RecipeListItem]
    let timestamp: Date
}

protocol TimestampExpirationPolicy {
    func isValid(_: Date) -> Bool
}

class RecipieListCache {
    enum Error: Swift.Error {
        case empty
        case expired
    }
    
    let storage: InMemoryStorage<RecipeListStored>
    let expirationPolicy: TimestampExpirationPolicy
    
    init(storage: InMemoryStorage<RecipeListStored>, expirationPolicy: TimestampExpirationPolicy) {
        self.storage = storage
        self.expirationPolicy = expirationPolicy
    }
    
    func read() -> Result<[RecipeListItem], Error> {
        if let stored = storage.read() {
            if expirationPolicy.isValid(stored.timestamp) {
                return .success(stored.items)
            } else {
                return .failure(.expired)
            }
        } else {
            return .failure(.empty)
        }
    }
    
    func write(_ items: [RecipeListItem]) {
        storage.write(RecipeListStored(items: items, timestamp: Date()))
    }
}

class RecipieListCacheTests: XCTestCase {
    func test_cache_isEmptyUponCreation() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.read(), .failure(.empty))
    }
    
    func test_read_returnsPreviouslyWrittenDataWhenNotExpired() {
        let (sut, validator) = makeSUT()
        
        let expectedData = RecipeListItem.makeTestItems()
        sut.write(expectedData)
        
        validator.validationResult = true
        
        XCTAssertEqual(sut.read(), .success(expectedData))
    }

    func test_read_returnsErrorWhenExpired() {
        let (sut, validator) = makeSUT()
        
        let expectedData = RecipeListItem.makeTestItems()
        sut.write(expectedData)
        validator.validationResult = false

        XCTAssertEqual(sut.read(), .failure(.expired))
    }

    private func makeSUT() -> (RecipieListCache, TimestampExpirationPolicyStub) {
        let storage = InMemoryStorage<RecipeListStored>()
        let validationStub = TimestampExpirationPolicyStub()
        let cache = RecipieListCache(storage: storage, expirationPolicy: validationStub)
        return (cache, validationStub)
    }
}

class TimestampExpirationPolicyStub: TimestampExpirationPolicy {
    var validationResult = false
    
    func isValid(_: Date) -> Bool {
        return validationResult
    }
}
