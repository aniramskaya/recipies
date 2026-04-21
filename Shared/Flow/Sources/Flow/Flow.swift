//
//  Flow.swift
//

public struct Flow<Value: Sendable>: Sendable {
    let operation: @Sendable () async throws -> Value

    public init(_ operation: @escaping @Sendable () async throws -> Value) {
        self.operation = operation
    }

    public func run() async throws -> Value {
        try await operation()
    }
}
