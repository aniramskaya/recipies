//
//  RecipeListItem+TestHelpers.swift
//  RecipeListTests
//
//  Created by Марина Чемезова on 05.11.2023.
//

import Foundation
import RecipeList

extension RecipeListItem {
    static func makeTestItems() -> [RecipeListItem] {
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
    
    static func makeTestItems2() -> [RecipeListItem] {
        [
            .init(
                id: UUID(uuidString: "11fb3a12-62fc-401e-861f-11594fe87c38")!,
                name: "Солянка сборная мясная",
                cookingTime: 75 * 60,
                imageUrl: URL(string: "https://any-url.com")!,
                rating: 3.5
            ),
            .init(
                id: UUID(uuidString: "674615e9-8c95-43f5-aa4f-38721717da99")!,
                name: "Лагман домашний",
                cookingTime: 135 * 60,
                imageUrl: URL(string: "https://another-any-url.com")!,
                rating: 4.8
            ),
        ]
    }
}
