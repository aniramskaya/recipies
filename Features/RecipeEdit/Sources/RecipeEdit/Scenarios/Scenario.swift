//
//  Scenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

public protocol Scenario {
    associatedtype State: Sendable
    
    var currentState: State { get }
    var futureStates: AsyncStream<State> { get }
}
