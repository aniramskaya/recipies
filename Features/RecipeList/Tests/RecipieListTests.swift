//
//  RecipieListTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 14.10.2023.
//

import XCTest
@testable import RecipieList

/*
 Сценарий загрузки списка рецептов
 
 Проверить время последней загрузки данных и убедиться, что оно пустое или прошел час или более.
 Запросить данные с сервера
 Запомнить новое время последней загрузки
 Вернуть список рецептов вызывающему коду

 Расширения

 1a. Прошло менее часа с момента последней загрузки
 вернуть имеющиеся в памяти данные

 2a. Выполнение запроса к серверу завершилось ошибкой и в памяти есть ранее загруженные данные
 вернуть имеющиеся данные

 ✅ 2б. Выполнение запроса к серверу завершилось ошибкой и в памяти нет ранее загруженных данных
 вернуть ошибку, которая пришла от сервера

 */
struct RecipeListItem {
    let id: UUID
    let name: String
    let cookingTime: TimeInterval
    let imageUrl: URL
    let rating: Float?
}

protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

class ReceipeListLoader {
    let dtoLoader: DTOLoader
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
    
    func load(completion: @escaping (Result<RecipeListItem, Error>) -> Void) {
        dtoLoader.load { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            default:
                break
            }
        }
    }
}

final class RecipieListTests: XCTestCase {
    func test_init_doesNothing() throws {
        let (_, spy) = makeSUT()

        XCTAssertEqual(spy.messages, [])
    }
    
    // Выполнение запроса к серверу завершилось ошибкой и в памяти нет ранее загруженных данных вернуть ошибку, которая пришла от сервера
    func test_loadingError_deliversErrorWhenNoCache() throws {
        let (sut, spy) = makeSUT()
        let expectedError = NSError.any()
        
        let exp = expectation(description: "Wait for async to complete")
        sut.load(completion: { result in
            switch result {
            case .success: XCTFail("Expected remote loading error, got success")
            case let .failure(error): XCTAssertEqual(error as NSError, expectedError)
            }
            exp.fulfill()
        })
        
        spy.complete(with: .failure(expectedError))
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT() -> (ReceipeListLoader, DTOLoaderSpy) {
        let spy = DTOLoaderSpy()
        let sut = ReceipeListLoader(dtoLoader: spy)
        return (sut, spy)
    }
}

extension NSError {
    static func any() -> NSError {
        NSError(domain: UUID().uuidString, code: 1)
    }
}

class DTOLoaderSpy: DTOLoader {
    enum Message: Equatable {
        case load
    }
    
    var messages: [Message] = []
    var completions: [(Result<RecipeListDTO, Error>) -> Void] = []
    
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void) {
        messages.append(.load)
        completions.append(completion)
    }
    
    func complete(with result: Result<RecipeListDTO, Error>, at index: Int = 0) {
        completions[index](result)
    }
}
