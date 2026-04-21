//
//  Flow.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

struct Flow<Value: Sendable>: Sendable {
    let operation: @Sendable () async throws -> Value
    
    init(_ operation: @escaping @Sendable () async throws -> Value) {
        self.operation = operation
    }
    
    func run() async throws -> Value {
        try await operation()
    }
}
