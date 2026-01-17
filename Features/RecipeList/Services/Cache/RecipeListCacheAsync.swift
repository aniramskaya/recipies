//
//  RecipeListCacheAsync.swift
//  RecipeList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

class RecipeListCacheAsync: RecipeListLoader {
    let cache: RecipeListCache
    init(cache: RecipeListCache) {
        self.cache = cache
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        completion(cache.read().mapError { $0 as Swift.Error } )
    }
    
    public func write(_ items: [RecipeListItem]) {
        cache.write(items)
    }
}
