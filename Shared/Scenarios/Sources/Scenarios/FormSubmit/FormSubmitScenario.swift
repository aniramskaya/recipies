//
//  RecipeFormSumbitScenario.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 12.05.2026.
//

import Foundation

public final class FormSubmitScenario<RawData: Sendable, Model: Sendable>: Sendable {
    private let getModel: @Sendable () async -> RawData?
    private let validate: @Sendable (RawData) async -> Result<Model, FormValidationError>
    private let save: @Sendable (_: Model) async throws -> Void
    
    public init(
        getModel: @escaping @Sendable () async -> RawData?,
        validate: @escaping @Sendable (RawData) async -> Result<Model, FormValidationError>,
        save: @escaping @Sendable (_: Model) async throws -> Void
    ) {
        self.getModel = getModel
        self.validate = validate
        self.save = save
    }
    
    // MARK: FormSubmitScenario
        
    public func start() -> AsyncStream<FormSubmitState> {
        let (stream, continuation) = AsyncStream.makeStream(
            of: FormSubmitState.self,
            bufferingPolicy: .bufferingNewest(1)
        )
        let task = Task {
            continuation.yield(.validating)
            guard !Task.isCancelled else { continuation.finish(); return }
            guard let model = await getModel() else { return }
            guard !Task.isCancelled else { continuation.finish(); return }
            switch await validate(model) {
            case let .success(data):
                continuation.yield(.saving)
                guard !Task.isCancelled else { continuation.finish(); return }
                do {
                    try await save(data)
                    guard !Task.isCancelled else { continuation.finish(); return }
                    continuation.yield(.saved)
                    continuation.finish()
                } catch {
                    guard !Task.isCancelled else { continuation.finish(); return }
                    continuation.yield(.savingFailed(error))
                    continuation.finish()
                }
            case let .failure(error):
                continuation.yield(.validationFailed(error))
                continuation.finish()
            }
        }
        continuation.onTermination = { _ in task.cancel() }
        return stream
    }
}
