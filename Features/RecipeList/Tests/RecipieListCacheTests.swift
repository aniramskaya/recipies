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
 До истечения времени жизни кэша он возвращает данные
 После истечения времени жизни кэша он возвращает ошибку
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

class RecipieListCache {
    let storage: InMemoryStorage<RecipeListStored>
    //let expirationPolicy: TimestampExpirationPolicy
    
    init(storage: InMemoryStorage<RecipeListStored>) {
        self.storage = storage
    }
    
    func read() -> [RecipeListItem]? {
        return storage.read()?.items
    }
    
    func write(_ items: [RecipeListItem]) {
        storage.write(RecipeListStored(items: items, timestamp: Date()))
    }
}

class RecipieListCacheTests: XCTestCase {
    func test_cache_isEmptyUponCreation() {
        let sut = makeSUT()

        XCTAssertNil(sut.read())
    }
    
    func test_read_returnsPreviouslyWrittenDataWhenNotExpired() {
        let sut = makeSUT()
        
        let expectedData = RecipeListItem.makeTestItems()
        sut.write(expectedData)
        
        XCTAssertEqual(sut.read(), expectedData)
    }

//    func test_read_returnsErrorWhenExpired() {
//        let sut = makeSUT()
//        
//        let expectedData = RecipeListItem.makeTestItems()
//        sut.write(expectedData)
//        
//        XCTAssertEqual(sut.read(), expectedData)
//    }

    private func makeSUT() -> RecipieListCache {
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipieListCache(storage: storage)
        return cache
    }
}
