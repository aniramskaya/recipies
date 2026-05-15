//
//  CurrentValueStream.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

@preconcurrency import Combine
import Foundation

//public final class CurrentValueStream<Value: Sendable>: @unchecked Sendable {
//    private let subject: CurrentValueSubject<Value, Never>
//    
//    public init(_ initial: Value) {
//        subject = CurrentValueSubject(initial)
//    }
//    
//    public var current: Value {
//        subject.value
//    }
//    
//    public func yield(_ value: Value) {
//        subject.send(value)
//    }
//    
//    public func finish() {
//        subject.send(completion: .finished)
//    }
//    
//    // каждый вызов создает независимый стрим с текущим значением первым
//    public func makeStream() -> AsyncStream<Value> {
//        AsyncStream { continuation in
//            let cancellable = self.subject
//                .sink (
//                    receiveCompletion: { _ in
//                        print("finishing")
//                        continuation.finish()
//                    },
//                    receiveValue: {
//                        value in
//                        print("yielding \(value)")
//                        continuation.yield(value)
//                    }
//                )
//            
//            continuation.onTermination = { _ in
//                print("cancelling")
//                cancellable.cancel()
//            }
//        }
//    }
//}

public actor CurrentValueStream<Value: Sendable> {
    private var currentValue: Value
    private var continuations: [UUID: AsyncStream<Value>.Continuation] = [:]
    private var isFinished = false

    public init(_ initial: Value) {
        currentValue = initial
    }

    public var current: Value {
        currentValue
    }

    public func yield(_ value: Value) {
        guard !isFinished else { return }

        currentValue = value

        for continuation in continuations.values {
            continuation.yield(value)
        }
    }

    public func finish() {
        guard !isFinished else { return }

        isFinished = true

        for continuation in continuations.values {
            continuation.finish()
        }

        continuations.removeAll()
    }

    public func makeStream() -> AsyncStream<Value> {
        AsyncStream { continuation in
            let id = UUID()

            continuation.yield(currentValue)

            if isFinished {
                continuation.finish()
                return
            }

            continuations[id] = continuation

            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(id)
                }
            }
        }
    }

    private func removeContinuation(_ id: UUID) {
        continuations.removeValue(forKey: id)
    }
}
