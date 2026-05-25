//
//  LoadingScenarioState.swift
//  Scenarios
//
//  Created by Марина Чемезова on 12.05.2026.
//

public enum LoadingScenarioState<Resource: Sendable>: Sendable {
    case loading
    case failure(Error)
    case loaded(Resource)
}
