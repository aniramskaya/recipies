//
//  RecipeListCacheTests.swift
//  recipies
//
//  Created by Марина Чемезова on 15.12.2023.
//

import Foundation
import XCTest
import RecipieList

/**
 
До истечения времени жизни кэша он возвращает данные
После истечения времени жизни кэша он возвращает ошибку "Время истекло"

 ✅ При инициализации кэш пуст
 ✅ При запросе данных из пустого кэша он возвращает ошибку "Кэш пуст"
 
 */

enum RecipeListCacheError: Error {
    case empty
    case expired
    case system(Error)
}

struct RecipeListStoring: Equatable {
    let timestamp: Date
    let data: [RecipeListItem]
}

enum StorageError: Error {
    case empty
    case system(Error)
}

protocol Storage {
    func load(completion: @escaping (Result<RecipeListStoring, StorageError>) -> Void)
    func save(data: RecipeListStoring, completion: @escaping (StorageError?) -> Void)
    func clear(completion: @escaping (StorageError?) -> Void)
}

class RecipeListCache {
    let policy: TimestampValidationPolicy
    let storage: Storage
    
    init(policy: TimestampValidationPolicy, storage: Storage) {
        self.policy = policy
        self.storage = storage
    }
    
    func load(completion: @escaping (Result<RecipeListStoring, RecipeListCacheError>) -> Void) {
        storage.load { result in
            switch result {
            case let .failure(error):
                switch error {
                case .empty:
                    completion(.failure(.empty))
                case let .system(error):
                    completion(.failure(.system(error)))
                }
            default:
                break
            }
        }
    }
}

class RecipeListCacheTests: XCTestCase {
    func test_cacheIsEmptyUponCreation_returnsCacheEmptyError() {
        let policy = TimeoutPolicy(60)
        let storage = StorageSpy()
        let sut = RecipeListCache(policy: policy, storage: storage)
        
        expect(sut: sut, toCompleteWith: .failure(RecipeListCacheError.empty)) {
            storage.completeLoading(with: .failure(StorageError.empty))
        }
    }

    private func expect(
        sut: RecipeListCache,
        toCompleteWith expectedResult: Result<RecipeListStoring, Error>,
        when: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for async to complete")
        sut.load(completion: { result in
            switch (result, expectedResult) {
            case let (.success(items), .success(expectedItems)):
                XCTAssertEqual(items, expectedItems, file: file, line: line)
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        when()
        wait(for: [exp], timeout: 1.0)

    }

}

class StorageSpy: Storage {
    enum Message: Equatable{
        case load
        case save(RecipeListStoring)
        case clear
    }
    
    var messages: [Message] = []
    
    var loadCompletions: [(Result<RecipeListStoring, StorageError>) -> Void] = []
    var saveCompletions: [(StorageError?) -> Void] = []
    var clearCompletions: [(StorageError?) -> Void] = []
    
    func load(completion: @escaping (Result<RecipeListStoring, StorageError>) -> Void) {
        messages.append(.load)
        loadCompletions.append(completion)
    }
    
    func save(data: RecipeListStoring, completion: @escaping (StorageError?) -> Void){
        messages.append(.save(data))
        saveCompletions.append(completion)
    }
    
    func clear(completion: @escaping (StorageError?) -> Void) {
        messages.append(.clear)
        clearCompletions.append(completion)
    }
    
    func completeLoading(with result: Result<RecipeListStoring, StorageError>, at index: Int = 0) {
        loadCompletions[index](result)
    }
    
    func completeSaving(with result: StorageError?, at index: Int = 0) {
        saveCompletions[index](result)
    }
    
    func completeClear(with result: StorageError?, at index: Int = 0) {
        clearCompletions[index](result)
    }
}
