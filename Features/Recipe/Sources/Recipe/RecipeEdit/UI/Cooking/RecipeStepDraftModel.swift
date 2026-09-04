//
//  RecipeStepDraftModel.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import Foundation

public struct RecipeStepDraftModel: Sendable, Identifiable {
    public let id: UUID
    public var title: String
    public var imageSource: URL?
    public var text: String
    
    public init(id: UUID, title: String, imageSource: URL?, text: String) {
        self.id = id
        self.title = title
        self.imageSource = imageSource
        self.text = text
    }
}
