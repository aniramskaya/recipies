//
//  Fallback.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func fallback(_ fallback: @escaping @Sendable () async throws -> Value) -> Flow<Value> {
        Flow {
            do {
                return try await self.operation()
            } catch let primaryError {
                do {
                    return try await fallback()
                } catch {
                    throw primaryError
                }
            }
        }
    }
}
