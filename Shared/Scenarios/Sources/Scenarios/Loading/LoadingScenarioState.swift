//
//  LoadingScenarioState.swift
//  Scenarios
//
//  Created by Марина Чемезова on 12.05.2026.
//

/// The state of a loading operation managed by ``BasicLoadingScenario``.
public enum LoadingScenarioState<Resource: Sendable>: Sendable {
    /// The resource is being fetched.
    case loading
    /// The fetch failed with the given error.
    case failure(Error)
    /// The fetch succeeded and the resource is available.
    case loaded(Resource)
}
