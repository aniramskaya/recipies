//
//  Map.swift
//

extension Flow {
    public func map<NewValue: Sendable>(
        _ transform: @escaping @Sendable (Value) async throws -> NewValue
    ) -> Flow<NewValue> {
        Flow<NewValue> {
            let value = try await self.operation()
            return try await transform(value)
        }
    }
}
