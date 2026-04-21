//
//  OnSuccess.swift
//

extension Flow {
    public func onSuccess(
        _ action: @escaping @Sendable (Value) async -> Void
    ) -> Flow<Value> {
        Flow {
            let value = try await self.operation()
            await action(value)
            return value
        }
    }
}
