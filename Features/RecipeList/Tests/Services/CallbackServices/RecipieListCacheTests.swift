//
//  RecipeListCache.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation
import XCTest
@testable import RecipeList

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

class RecipeListCacheTests: XCTestCase {
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

    private func makeSUT() -> (RecipeListCache, TimestampExpirationPolicyStub) {
        let storage = InMemoryStorage<RecipeListStored>()
        let validationStub = TimestampExpirationPolicyStub()
        let cache = RecipeListCache(storage: storage, expirationPolicy: validationStub)
        return (cache, validationStub)
    }
}

final class TimestampExpirationPolicyStub: TimestampExpirationPolicy {
    var validationResult = false
    
    func isValid(_: Date) -> Bool {
        return validationResult
    }
}
