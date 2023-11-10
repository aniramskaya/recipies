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

 2б. Выполнение запроса к серверу завершилось ошибкой и в памяти нет ранее загруженных данных
 вернуть ошибку, которая пришла от сервера

 */
protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

class ReceipeListLoader {
    let dtoLoader: DTOLoader
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
}

final class RecipieListTests: XCTestCase {
    func test_init_doesNothing() throws {
        let spy = DTOLoaderSpy()
        let sut = ReceipeListLoader(dtoLoader: spy)
        
        XCTAssertEqual(spy.messages, [])
    }
}

class DTOLoaderSpy: DTOLoader {
    enum Message: Equatable {
        case load
    }
    
    var messages: [Message] = []
    
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void) {
        messages.append(.load)
    }
}
