//
//  RecipieListCacheAsync.swift
//  RecipieList
//
//  Created by Марина Чемезова on 06.11.2023.
//

import Foundation

class RecipieListCacheAsync: RecipieListLoader {
    let cache: RecipieListCache
    init(cache: RecipieListCache) {
        self.cache = cache
    }
    
    func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        completion(cache.read().mapError { $0 as Swift.Error } )
    }
    
    public func write(_ items: [RecipeListItem]) {
        cache.write(items)
    }
}
