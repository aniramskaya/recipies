//
//  CurrentValueStreamCombineLatest.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

public func combineLatest<A: Sendable, B: Sendable, Result: Sendable>(
    _ streamA: CurrentValueStream<A>,
    _ streamB: CurrentValueStream<B>,
    transform: @escaping @Sendable (A, B) -> Result
) async -> CurrentValueStream<Result> {
    let initialA = await streamA.current
    let initialB = await streamB.current

    let state = CombineLatestState(
        a: initialA,
        b: initialB
    )

    let resultStream = CurrentValueStream<Result>(
        transform(initialA, initialB)
    )

    let streamAValues = await streamA.makeStream()
    let streamBValues = await streamB.makeStream()

    Task {
        async let collectA: Void = {
            for await value in streamAValues {
                await state.updateA(value)

                let (a, b) = await state.values()

                await resultStream.yield(
                    transform(a, b)
                )
            }
        }()

        async let collectB: Void = {
            for await value in streamBValues {
                await state.updateB(value)

                let (a, b) = await state.values()

                await resultStream.yield(
                    transform(a, b)
                )
            }
        }()

        _ = await (collectA, collectB)

        await resultStream.finish()
    }

    return resultStream
}

private actor CombineLatestState<A: Sendable, B: Sendable> {
    var latestA: A
    var latestB: B

    init(a: A, b: B) {
        latestA = a
        latestB = b
    }

    func updateA(_ value: A) {
        latestA = value
    }

    func updateB(_ value: B) {
        latestB = value
    }

    func values() -> (A, B) {
        (latestA, latestB)
    }
}
