//
//  CallAsFunction.swift
//  recipies
//
//  Created by Марина Чемезова on 07.04.2026.
//

extension Flow {
    func callAsFunction() async throws -> Value {
        try await run()
    }
}
