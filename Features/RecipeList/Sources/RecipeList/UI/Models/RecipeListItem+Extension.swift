//
//  RecipeListItem+Extension.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//
private extension RecipeListItem {
    func asViewModel() -> RecipeListRowModel {
        .init(
            id: self.id,
            name: self.name,
            imageSource: .remote(self.imageUrl),
            cookingTimeMins: self.cookingTimeMins,
            complexity: self.complexity
        )
    }
}


extension Array where Element == RecipeListItem {
    func asViewModels() -> [RecipeListRowModel] {
        self.map { item in item.asViewModel() }
    }
}
