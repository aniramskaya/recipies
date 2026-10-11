//
//  RecipeStep.swift
//  RecipeStorage
//
//  Created by Марина Чемезова on 07.10.2026.
//
import Foundation
import SwiftData
import RecipeTypes

@Model
class RecipeStepModel {
    var id: UUID
    var title: String?
    var imageSource: URL?
    var text: String
    var sortOrder: Int
    
    init(id: UUID, title: String? = nil, imageSource: URL? = nil, text: String, sortOrder: Int) {
        self.id = id
        self.title = title
        self.imageSource = imageSource
        self.text = text
        self.sortOrder = sortOrder
    }
}

extension RecipeStepModel {
    var domain: RecipeStep {
        .init(id: id, title: title, imageSource: imageSource, text: text)
    }
    
    static func from(_ domain: RecipeStep, index: Int) -> RecipeStepModel {
        .init(
            id: domain.id,
            title: domain.title,
            imageSource: domain.imageSource,
            text: domain.text,
            sortOrder: index
        )
    }
}
