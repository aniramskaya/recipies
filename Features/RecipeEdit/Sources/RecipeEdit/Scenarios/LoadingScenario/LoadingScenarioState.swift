//
//  LoadingScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

public enum LoadingScenarioState<Resource: Sendable>: Sendable {
    case idle
    case loading
    case success(Resource)
    case failure(Error)
    case finished
}

