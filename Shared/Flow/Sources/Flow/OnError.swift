//
//  OnError.swift
//

extension Flow {
    public func onError(
        _ action: @escaping @Sendable (Error) async -> Void
    ) -> Flow<Value> {
        Flow {
            do {
                return try await self.operation()
            } catch {
                await action(error)
                throw error
            }
        }
    }
}
