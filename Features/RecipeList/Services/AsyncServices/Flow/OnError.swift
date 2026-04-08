//
//  OnError.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func onError(
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
