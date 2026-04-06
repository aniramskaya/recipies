//
//  RecipeListDTO.swift
//  recipes
//
//  Created by Марина Чемезова on 13.01.2026.
//
@testable import RecipeList

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
