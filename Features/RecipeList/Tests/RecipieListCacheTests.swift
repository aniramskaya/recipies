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
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipieListCache(storage: storage)
        
        XCTAssertNil(cache.read())
    }
    
    func test_read_returnsPreviouslyWrittenDataWhenNotExpired() {
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipieListCache(storage: storage)
        
        let expectedData = RecipeListItem.makeTestItems()
        cache.write(expectedData)
    }
}
