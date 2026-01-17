//
//  RecipeListFallbackLoader.swift
//  RecipeList
//
//  Created by Марина Чемезова on 14.10.2023.
//

import Foundation

public class RecipeListFallbackLoader: RecipeListLoader {
    let first: RecipeListLoader
    let second: RecipeListLoader

    public init(first: RecipeListLoader, second: RecipeListLoader) {
        self.first = first
        self.second = second
    }
    
    public func load(completion: @escaping (Result<[RecipeListItem], Error>) -> Void) {
        first.load { [weak self] result in
            switch result {
            case .success(let items):
                completion(.success(items))
            case let .failure(error):
                self?.second.load { result in
                    switch result {
                    case let .success(items):
                        completion(.success(items))
                    case .failure:
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
