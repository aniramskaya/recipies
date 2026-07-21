//
//  AsyncRecipeListLoaderStub.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//
import Foundation

actor AsyncRecipeListLoaderStub: RecipeListLoader {
    private let results: [Result<[RecipeListItem], Error>]
    private(set) var resultIndex = 0

    init(
        results: [Result<[RecipeListItem], Error>] = [.success(AsyncRecipeListLoaderStub.stubData)],
    ) {
        self.results = results
    }

    func load() async throws -> [RecipeListItem] {
        let index = min(resultIndex, results.count - 1)
        resultIndex += 1
        switch results[index] {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    private static let stubData: [RecipeListItem] = [
        .init(
            id: UUID(uuidString: "c1fb3a12-62fc-401e-861f-11594fe87c32")!,
            name: "Котлеты по-киевски",
            cookingTime: 75 * 60,
            imageUrl: URL(string: "https://www.russianfood.com/dycontent/images_upl/484/sm_483636.jpg")!,
            rating: 3.5,
            complexity: 2
        ),
        .init(
            id: UUID(uuidString: "474615e9-8c95-43f5-aa4f-38721717da98")!,
            name: "Лапша Удон с курицей",
            cookingTime: 35 * 60,
            imageUrl: URL(string: "https://cdn.nur.kz/images/1200x675/b1da4e229e725cbd.webp?version=1")!,
            rating: 4.8,
            complexity: 3
        ),
    ]
}
