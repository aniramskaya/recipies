//
//  RecipieListTests.swift
//  RecipieListTests
//
//  Created by Марина Чемезова on 14.10.2023.
//

import XCTest
@testable import RecipieList

protocol DTOLoader {
    func load(completion: @escaping (Result<RecipeListDTO, Error>) -> Void)
}

class RecipieListLoader {
    let dtoLoader: DTOLoader
    
    init(dtoLoader: DTOLoader) {
        self.dtoLoader = dtoLoader
    }
}

final class RecipieListTests: XCTestCase {
    func test_init_doesNothing() throws {
        let spy = DTOLoaderSpy()
        let sut = RecipieListLoader(dtoLoader: spy)
        
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
