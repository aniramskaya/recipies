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
 ✅   or an hour or more has passed since
 ✅ Request new data from server
 ✅ Memorize last loaded time
 ✅ Return recipie list to the calling code
 
 ✅ 1a. Less then an hour has passed since last load: return in-memory data
 ✅ 2a. Remote loading has failed and there are in-memory data: return in-memory data
 ✅ 2b. Remote loading has failed and there are no in-memory data: return remote loading error
*/

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
 
    // First load: load from remote
    // Less then an hour has passed since last load: return in-memory data
    // An exactly hour has passed since last load: load from remote
    // More than hour has passed since last load: load from remote
    func test_loadingSuccess_deliversSuccessWhenNoCache() throws {
        let (sut, spy) = makeSUT()
        let expectedData = makeTestItems()

        // first load
        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()), at: 0)
        }
        XCTAssertEqual(spy.messages, [.load])
        XCTAssertNotNil(sut.lastLoaded)
        
        // Cache is not expired, return in-memory data
        sut.lastLoaded = Date().addingMinutes(-60)?.addingSeconds(1)
        
        expect(sut: sut, toCompleteWith: .success(expectedData)) { }
        XCTAssertEqual(spy.messages, [.load])

        // Cache has just expired, load from remote
        sut.lastLoaded = Date().addingMinutes(-60)
        
        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()), at: 1)
        }
        XCTAssertEqual(spy.messages, [.load, .load])

        // Cache is expired, load from remote
        sut.lastLoaded = Date().addingMinutes(-60)?.addingSeconds(-1)
        
        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()), at: 2)
        }
        XCTAssertEqual(spy.messages, [.load, .load, .load])
    }

    // Remote loading has failed and there are in-memory data: return in-memory data
    func test_loadingSuccess_deliversSuccessWhenCacheIsExpiredAndRemoteLoadingFails() throws {
        let (sut, spy) = makeSUT()
        let expectedData = makeTestItems()
        
        // first load
        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .success(.test()), at: 0)
        }
        XCTAssertEqual(spy.messages, [.load])
        XCTAssertNotNil(sut.lastLoaded)
        
        //cache has become expired
        sut.lastLoaded = Date().addingMinutes(-120)
        
        //second load finishes with error but we got cache data
        expect(sut: sut, toCompleteWith: .success(expectedData)) {
            spy.complete(with: .failure(NSError.any()), at: 1)
        }
        XCTAssertEqual(spy.messages, [.load, .load])
    }
    
    // MARK: Private
    
    private func makeSUT() -> (RecipieListLoader, DTOLoaderSpy) {
        let spy = DTOLoaderSpy()
        let sut = RecipieListLoader(dtoLoader: spy)
        return (sut, spy)
    }
    
    private func expect(sut: RecipieListLoader, toCompleteWith expectedResult: Result<[RecipeListItem], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for async code to complete")
        sut.load { result in
            switch (result, expectedResult) {
            case let (.success(items), .success(expectedItems)):
                XCTAssertEqual(items, expectedItems, file: file, line: line)
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
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

extension Date {
    func addingMinutes(_ value: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: value, to: self)
    }
    func addingSeconds(_ value: Int) -> Date? {
        Calendar.current.date(byAdding: .second, value: value, to: self)
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
