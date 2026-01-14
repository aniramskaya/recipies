//
//  RecipeListItem+Extension.swift
//  recipies
//
//  Created by Марина Чемезова on 14.01.2026.
//

private extension RecipeListItem {
    func asViewModel() -> RecipeListRowModel {
        .init(
            id: self.id,
            name: self.name,
            imageSource: .remote(self.imageUrl),
            cookingTimeMins: Int(floor(self.cookingTime / 60)),
            rating: self.rating ?? 0
        )
    }
}


extension Array where Element == RecipeListItem {
    func asViewModels() -> [RecipeListRowModel] {
        self.map { item in item.asViewModel() }
    }
}
