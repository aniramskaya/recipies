//
//  Flow.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

struct Flow<Value> {
    let operation: () async throws -> Value
    
    init(_ operation: @escaping () async throws -> Value) {
        self.operation = operation
    }
    
    func run() async throws -> Value {
        try await operation()
    }
}
