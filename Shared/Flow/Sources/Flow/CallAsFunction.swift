//
//  CallAsFunction.swift
//

extension Flow {
    public func callAsFunction() async throws -> Value {
        try await run()
    }
}
