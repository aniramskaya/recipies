//
//  RecipieListInMemoryStorageTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation
import XCTest
@testable import RecipieList
/*
 ✅ При инициализации хранилище пустое
 ✅ Чтение хранилища после записи возвращает записанный результат
 ✅ Повторное чтение не имеет побочных эффектов
 ✅ Чтение хранилища после удаления возвращает пустое значение
 ✅ Повторное удаление не имеет побочных эффектов
 */
/*
 Storage is empty upon creation
 Reading from storage after write returns written value
 Double reading has no side-effects
 Reading from storage after deletion returns empty value
 Double deletion has no side-effects
 */

class RecipieListInMemoryStorage {
    var data: [RecipeListItem]?
    
    func read() -> [RecipeListItem]? {
        return data
    }
    
    func write(_ items: [RecipeListItem]) {
        data = items
    }
    
    func delete() {
        data = nil
    }
}

class RecipieListInMemoryStorageTests: XCTestCase {
    func test_init_makesEmptyStprage() throws {
        let sut = RecipieListInMemoryStorage()
        
        XCTAssertNil(sut.read(), "Storage is expected to be empty upon creation but it is not")
    }
    
    func test_read_returnsWrittenValue() throws {
        let sut = RecipieListInMemoryStorage()
        let items = RecipeListItem.makeTestItems()
        
        sut.write(items)
        
        XCTAssertEqual(sut.read(), items)
    }
    
    func test_read_hasNoSideEffects() throws {
        let sut = RecipieListInMemoryStorage()
        let items = RecipeListItem.makeTestItems()
        
        sut.write(items)
        
        XCTAssertEqual(sut.read(), items)
        XCTAssertEqual(sut.read(), items)
    }
    
    func test_delete_makesDataNil() throws {
        let sut = RecipieListInMemoryStorage()
        let items = RecipeListItem.makeTestItems()
        
        sut.write(items)
        
        XCTAssertEqual(sut.read(), items)
        
        sut.delete()
        
        XCTAssertNil(sut.read())
    }
    
    func test_doubleDelete_hasNoSideEffects() throws {
        let sut = RecipieListInMemoryStorage()
        let items = RecipeListItem.makeTestItems()
        
        sut.write(items)
        
        XCTAssertEqual(sut.read(), items)
        
        sut.delete()
        
        XCTAssertNil(sut.read())

        sut.delete()
        
        XCTAssertNil(sut.read())
    }
}
