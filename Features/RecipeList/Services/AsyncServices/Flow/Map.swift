//
//  Map.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func map<NewValue>(
        _ transform: @escaping (Value) -> NewValue
    ) -> Flow<NewValue> {
        Flow<NewValue> {
            let value = try await self.operation()
            return transform(value)
        }
    }
}
