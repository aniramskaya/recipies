//
//  RecipieListFallbackLoader.swift
//  RecipieList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public class RecipieListFallbackLoader: RecipieListLoader {
    let first: RecipieListLoader
    let second: RecipieListLoader

    public init(first: RecipieListLoader, second: RecipieListLoader) {
        self.first = second
        self.second = first
    }
    
    public func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        first.load { [weak self] result in
            switch result {
            case .success(let items):
                completion(.success(items))
            case .failure:
                self?.second.load(completion: completion)
            }
        }
    }
}
