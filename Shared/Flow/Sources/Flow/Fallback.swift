//
//  Fallback.swift
//

extension Flow {
    public func fallback(_ fallback: @escaping @Sendable () async throws -> Value) -> Flow<Value> {
        Flow {
            do {
                return try await self.operation()
            } catch  {
                try Task.checkCancellation()
                return try await fallback()
            }
        }
    }
}
