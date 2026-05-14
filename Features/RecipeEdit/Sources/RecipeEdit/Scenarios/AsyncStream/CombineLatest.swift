//
//  CombineLatest.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.05.2026.
//

extension AsyncStream  {
    func combineLatest<Other: Sendable, Result: Sendable>(
        with other: AsyncStream<Other>,
        transform: @escaping @Sendable (Element, Other) -> Result
    ) -> AsyncStream<Result> where Element == Sendable {
        combineStreamsLatest(self, other, transform)
    }
}

private func combineStreamsLatest<A: Sendable, B: Sendable, Result: Sendable>(
    _ streamA: AsyncStream<A>,
    _ streamB: AsyncStream<B>,
    _ transform: @escaping @Sendable (A, B) -> Result
) -> AsyncStream<Result> {
    return AsyncStream { continuation in
        Task {
            let state = State<A, B>()
            
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    for await value in streamA {
                        if let pair = await state.setA(value) {
                            continuation.yield(transform(pair.0, pair.1))
                        }
                    }
                }
                group.addTask {
                    for await value in streamB {
                        if let pair = await state.setB(value) {
                            continuation.yield(transform(pair.0, pair.1))
                        }
                    }
                }
                continuation.finish()
            }
        }
    }
}

private actor State<A: Sendable, B: Sendable> {
    var lastA: A?
    var lastB: B?
    
    func setA(_ value: A) -> (A, B)? {
        lastA = value
        guard let lastB else { return nil }
        return (value, lastB)
    }
    
    func setB(_ value: B) -> (A, B)? {
        lastB = value
        guard let lastA else { return nil }
        return (lastA, value)
    }
}
