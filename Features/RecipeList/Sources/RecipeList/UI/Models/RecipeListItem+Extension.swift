//
//  RecipeListItem+Extension.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//
import RecipeUIKit

private extension RecipeListItem {
    func asViewModel() -> RecipeListRowModel {
        var source = RecipeImageSource.none
        if let imageUrl {
            source = .remote(imageUrl)
        }
        
        return RecipeListRowModel(
            id: id,
            name: name,
            imageSource: source,
            cookingTimeMins: cookingTimeMins,
            complexity: complexity
        )
    }
}


extension Array where Element == RecipeListItem {
    func asViewModels() -> [RecipeListRowModel] {
        self.map { item in item.asViewModel() }
    }
}
