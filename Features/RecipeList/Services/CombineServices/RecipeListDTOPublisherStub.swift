//
//  RecipeListDTOPublisherStub.swift
//  recipies
//
//  Created by Марина Чемезова on 17.01.2026.
//

import Combine

class RecipeListDTOPublisherStub: RecipeListDTOPublisher {
    private var result: Result<RecipeListDTO, Error>
    private let queue: DispatchQueue
    private let timeout: TimeInterval

    init(
        result: Result<RecipeListDTO, Error> = .success(RecipeListDTOPublisherStub.stubData),
        queue: DispatchQueue = DispatchQueue.global(),
        timeout: TimeInterval = 0.5
    ) {
        self.result = result
        self.queue = queue
        self.timeout = timeout
    }
    
    func publisher() -> AnyPublisher<RecipeListDTO, Error> {
        return Future<RecipeListDTO, Error> { [result, timeout, queue] promise in
            queue.asyncAfter(deadline: .now() + timeout) {
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private static let stubData: RecipeListDTO = .init(items: [
        .init(
            id: UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!,
            name: "Котлеты по-киевски",
            cookingTime: 75,
            imageUrl: URL(string: "https://www.russianfood.com/dycontent/images_upl/484/sm_483636.jpg")!,
            rating: 3.5
        ),
        .init(
            id: UUID(uuidString: "474615e9-8c95-43f5-aa4f-38721717da98")!,
            name: "Лапша Удон с курицей",
            cookingTime: 35,
            imageUrl: URL(string: "https://cdn.nur.kz/images/1200x675/b1da4e229e725cbd.webp?version=1")!,
            rating: 4.8
        ),
    ])
}

