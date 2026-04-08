//
//  Map.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func map<NewValue: Sendable>(
        _ transform: @escaping @Sendable (Value) -> NewValue
    ) -> Flow<NewValue> {
        Flow<NewValue> {
            let value = try await self.operation()
            return transform(value)
        }
    }
}
