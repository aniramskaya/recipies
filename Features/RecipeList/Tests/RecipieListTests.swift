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
/*
 Recipe list loading scenario
 
 ✅ Check last loaded time and ensure it is empty
    or an hour or more has passed since
 ✅ Request new data from server
 Memorize last loaded time
 ✅ Return recipie list to the calling code
 
 1a. Less then an hour has passed since last load: return in-memory data
 2a. Remote loading has failed and there are in-memory data: return in-memory data
 ✅ 2b. Remote loading has failed and there are no in-memory data: return remote loading error
*/

protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

struct RecipeListItem: Equatable {
    let id: UUID
    let name: String
    let cookingTime: TimeInterval
    let imageUrl: URL
    let rating: Float?
}

class RecipieListLoader {
    let dtoLoader: DTOLoader
    var cache: [RecipeListItem]?
    var lastLoaded: Date?
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        print((lastLoaded ?? .distantPast).addingTimeInterval(3600))
        print(Date())
        if let cache, (lastLoaded ?? .distantPast).addingTimeInterval(3600) > Date() {
            completion(.success(cache))
            return
        }
        dtoLoader.load { [weak self] result in
            switch result {
            case let .success(dto):
                var models: [RecipeListItem] = []
                for item in dto.items {
                    models.append(.init(id: item.id, name: item.name, cookingTime: Double(item.cookingTime * 60), imageUrl: item.imageUrl, rating: item.rating))
                }
                self?.cache = models
                completion(.success(models))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

final class RecipieListTests: XCTestCase {
    func test_init_doesNothing() throws {
        let (_, spy) = makeSUT()
        
        XCTAssertEqual(spy.messages, [])
    }
    
    // Выполнение запроса к серверу завершилось ошибкой и в памяти нет ранее загруженных данных
    // - вернуть ошибку, которая пришла от сервера
    // Remote loading has failed and there are no in-memory data: return remote loading error
    func test_loadingError_deliversErrorWhenNoCache() throws {
        let (sut, spy) = makeSUT()
        let error = NSError.any()

        expect(sut: sut, toCompleteWith: .failure(error)) {
            spy.complete(with: .failure(error))
        }
        XCTAssertEqual(spy.messages, [.load])
    }
 
    //    Проверить время последней загрузки данных и убедиться, что оно пустое или прошел час или более.
    //    Запросить данные с сервера
    //    Запомнить новое время последней загрузки
    //    Вернуть список рецептов вызывающему коду
    func test_loadingSuccess_deliversSuccessWhenNoCache() throws {
        let (sut, spy) = makeSUT()
        let expectedData = makeTestItems()

        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()))
        }
        XCTAssertEqual(spy.messages, [.load])
    }
    
    // Less then an hour has passed since last load: return in-memory data
    func test_load_deliversCacheDataWhenCacheNotExpired() throws {
        let (sut, spy) = makeSUT()
        let expectedData = makeTestItems()

        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()), at: 0)
        }
        XCTAssertEqual(spy.messages, [.load])
        
        sut.lastLoaded = Date().addingTimeInterval(1 - 3600)
        
        expect(sut: sut, toCompleteWith: .success(expectedData)) { }
        XCTAssertEqual(spy.messages, [.load])
    }

    // MARK: Private
    
    private func makeSUT() -> (RecipieListLoader, DTOLoaderSpy) {
        let spy = DTOLoaderSpy()
        let sut = RecipieListLoader(dtoLoader: spy)
        return (sut, spy)
    }
    
    private func expect(sut: RecipieListLoader, toCompleteWith expectedResult: Result<[RecipeListItem], Error>, when action: () -> Void) {
        let exp = expectation(description: "Wait for async code to complete")
        sut.load { result in
            switch (result, expectedResult) {
            case let (.success(items), .success(expectedItems)):
                XCTAssertEqual(items, expectedItems)
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError)
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead")
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeTestItems() -> [RecipeListItem] {
        [
            .init(
                id: UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!,
                name: "Котлеты по-киевски",
                cookingTime: 75 * 60,
                imageUrl: URL(string: "https://any-url.com")!,
                rating: 3.5
            ),
            .init(
                id: UUID(uuidString: "474615e9-8c95-43f5-aa4f-38721717da98")!,
                name: "Лапша Удон с курицей",
                cookingTime: 35 * 60,
                imageUrl: URL(string: "https://another-any-url.com")!,
                rating: 4.8
            ),
        ]
    }
}

extension RecipeListDTO {
    static func test() -> RecipeListDTO {
        .init(items: [
            .init(
                id: UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!,
                name: "Котлеты по-киевски",
                cookingTime: 75,
                imageUrl: URL(string: "https://any-url.com")!,
                rating: 3.5
            ),
            .init(
                id: UUID(uuidString: "474615e9-8c95-43f5-aa4f-38721717da98")!,
                name: "Лапша Удон с курицей",
                cookingTime: 35,
                imageUrl: URL(string: "https://another-any-url.com")!,
                rating: 4.8
            ),
        ])
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
