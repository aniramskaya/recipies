//
//  CombineLatest.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.05.2026.
//

actor CombinedScenario<A: Scenario, B: Scenario, Result: Sendable>: Scenario {
    typealias State = Result
    
    private let scenarioA: A
    private let scenarioB: B
    private let transform: @Sendable (A.State, B.State) -> Result

    public init(scenarioA: A, scenarioB: B, transform: @escaping @Sendable (A.State, B.State) -> Result) {
        self.scenarioA = scenarioA
        self.scenarioB = scenarioB
        self.transform = transform
    }

    func statesStream() async -> AsyncStream<State> {
        async let aStateStream = scenarioA.statesStream()
        async let bStateStream = scenarioB.statesStream()
        
        return combineStreamsLatest(await aStateStream, await bStateStream, transform)
    }
}
