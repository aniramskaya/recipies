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
        let module = makeSUT()
        
        XCTAssertEqual(module.spy.messages, [])
    }
    
    // Выполнение запроса к серверу завершилось ошибкой и в памяти нет ранее загруженных данных
    // - вернуть ошибку, которая пришла от сервера
    // Remote loading has failed and there are no in-memory data: return remote loading error
    func test_loadingError_deliversErrorWhenNoCache() throws {
        let module = makeSUT()
        let error = NSError.any()
        
        expect(sut: module.sut, toCompleteWith: .failure(error)) {
            module.spy.complete(with: .failure(error))
        }
        XCTAssertEqual(module.spy.messages, [.load])
    }
    
    // First load: load from remote
    // Less then an hour has passed since last load: return in-memory data
    // An exactly hour has passed since last load: load from remote
    // More than hour has passed since last load: load from remote
    func test_loading_deliversSuccessWhenNoCache() throws {
        let module = makeSUT()
        let expectedData = RecipeListItem.makeTestItems()
        
        // first load
        expect(sut: module.sut, toCompleteWith: .success(expectedData)) {
            module.spy.complete(with: .success(.test()))
        }
        XCTAssertEqual(module.spy.messages, [.load])
    }
    
    func test_loading_deliversSuccessWhenFreshCache() throws {
        let expectedData = RecipeListItem.makeTestItems()
        let module = makeSUT()
        module.expiration.validationResult = true

        expect(sut: module.sut, toCompleteWith: .success(expectedData)) { 
            module.spy.complete(with: .success(.test()))
        }
        expect(sut: module.sut, toCompleteWith: .success(expectedData)) { }
        XCTAssertEqual(module.spy.messages, [.load])
    }
    
    func test_loading_loadsFromRemoteWhenExpiredCache() throws {
        let expectedData1 = RecipeListItem.makeTestItems()
        let expectedData2 = RecipeListItem.makeTestItems2()
        let module = makeSUT()

        expect(sut: module.sut, toCompleteWith: .success(expectedData1)) {
            module.spy.complete(with: .success(.test()), at: 0)
        }
        module.expiration.validationResult = false
        expect(sut: module.sut, toCompleteWith: .success(expectedData2)) {
            module.spy.complete(with: .success(.test2()), at: 1)
        }
        XCTAssertEqual(module.spy.messages, [.load, .load])
    }

    // Remote loading has failed and there are in-memory data: return in-memory data
    func test_loadingSuccess_deliversSuccessWhenCacheIsExpiredAndRemoteLoadingFails() throws {
        let module = makeSUT()
        let expectedData = RecipeListItem.makeTestItems()
        
        // first load
        expect(sut: module.sut, toCompleteWith: .success(expectedData)) {
            module.spy.complete(with: .success(.test()), at: 0)
        }
        XCTAssertEqual(module.spy.messages, [.load])
        
        //cache has become expired
        module.expiration.validationResult = false

        //second load finishes with error but we got cache data
        expect(sut: module.sut, toCompleteWith: .success(expectedData)) {
            module.spy.complete(with: .failure(NSError.any()), at: 1)
        }
        XCTAssertEqual(module.spy.messages, [.load, .load])
    }
    
    // MARK: Private
    
    private struct SUTModule {
        let sut: RecipieListFallbackLoader
        let spy: DTOLoaderSpy
        let expiration: TimestampExpirationPolicyStub
    }
    
    private func makeSUT(data: [RecipeListItem]? = nil, time: Date? = nil, file: StaticString = #filePath, line: UInt = #line) -> SUTModule {
        let spy = DTOLoaderSpy()
        let expiration = TimestampExpirationPolicyStub()
        let storage = InMemoryStorage<RecipeListStored>()
        let cache = RecipieListCache(storage: storage, expirationPolicy: expiration)
        let cacheAsync = RecipieListCacheAsync(cache: cache)
        let remoteLoader = RecipieListRemoteLoader(dtoLoader: spy, cache: cache, storage: storage)
        let sut = RecipieListFallbackLoader(first: remoteLoader, second: cacheAsync)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(spy)
        trackForMemoryLeak(expiration)
        trackForMemoryLeak(storage)
        trackForMemoryLeak(cache)
        trackForMemoryLeak(cacheAsync)
        trackForMemoryLeak(remoteLoader)
        return SUTModule(sut: sut, spy: spy, expiration: expiration)
    }
    
    private func expect(sut: RecipieListFallbackLoader, toCompleteWith expectedResult: Result<[RecipeListItem], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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
    
    static func test2() -> RecipeListDTO {
        .init(items: [
            .init(
                id: UUID(uuidString: "11fb3a12-62fc-401e-861f-11594fe87c38")!,
                name: "Солянка сборная мясная",
                cookingTime: 75,
                imageUrl: URL(string: "https://any-url.com")!,
                rating: 3.5
            ),
            .init(
                id: UUID(uuidString: "674615e9-8c95-43f5-aa4f-38721717da99")!,
                name: "Лагман домашний",
                cookingTime: 135,
                imageUrl: URL(string: "https://another-any-url.com")!,
                rating: 4.8
            )
        ])
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
