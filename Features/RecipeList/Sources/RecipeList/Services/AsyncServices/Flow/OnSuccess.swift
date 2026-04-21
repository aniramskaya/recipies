//
//  OnSuccess.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func onSuccess(
        _ action: @escaping @Sendable (Value) async -> Void
    ) -> Flow<Value> {
        Flow {
            let value = try await self.operation()
            await action(value)
            return value
        }
    }
}
