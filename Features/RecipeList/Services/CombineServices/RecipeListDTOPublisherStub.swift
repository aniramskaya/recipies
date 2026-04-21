//
//  RecipeListDTOPublisherStub.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

final class RecipeListDTOPublisherStub: RecipeListDTOPublisher {
    private let results: [Result<RecipeListDTO, Error>]
    public private(set) var resultIndex = 0

    init(
        results: [Result<RecipeListDTO, Error>] = [.success(RecipeListDTOPublisherStub.stubData)],
    ) {
        self.results = results
    }
    
    func publisher() -> AnyPublisher<RecipeListDTO, Error> {
        let index = min(resultIndex, results.count - 1)
        resultIndex += 1
        switch results[index] {
        case let .success(value):
            return Just(value)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case let .failure(error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private static let stubData: RecipeListDTO = .init(items: [
        .init(
            id: UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!,
            name: "Котлеты по-киевски",
            cookingTime: 75,
            imageUrl: URL(string: "https://www.russianfood.com/dycontent/images_upl/484/sm_483636.jpg")!,
            rating: 3.5,
            complexity: 2
        ),
        .init(
            id: UUID(uuidString: "474615e9-8c95-43f5-aa4f-38721717da98")!,
            name: "Лапша Удон с курицей",
            cookingTime: 35,
            imageUrl: URL(string: "https://cdn.nur.kz/images/1200x675/b1da4e229e725cbd.webp?version=1")!,
            rating: 4.8,
            complexity: 3
        ),
    ])
}

