//
//  Scenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

public protocol Scenario: Sendable {
    associatedtype State: Sendable
    
    func statesStream() async -> AsyncStream<State>
}
