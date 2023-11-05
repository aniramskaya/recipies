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

class RecipieListCache {
    let storage: RecipieListInMemoryStorage
    
    init(storage: RecipieListInMemoryStorage) {
        self.storage = storage
    }
    
    func read() -> [RecipeListItem]? {
        return storage.read()
    }
}

class RecipieListCacheTests {
    func test_cache_isEmptyUponCreation() {
        let storage = RecipieListInMemoryStorage()
        let cache = RecipieListCache(storage: storage)
        
        XCTAssertNil(cache.read())
    }
}
