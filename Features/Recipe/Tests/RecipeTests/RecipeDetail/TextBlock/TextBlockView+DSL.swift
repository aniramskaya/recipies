//
//  TextBlockView+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import Recipe

extension InspectableView where View == ViewType.View<TextBlockView> {
    @MainActor
    func assertIsDisplaying(title: String?, text: String, sourceLocation: SourceLocation = #_sourceLocation) throws {
        if let title {
            guard let valueFound = try? self.find(viewWithAccessibilityIdentifier: A11y.title).text().string() else {
                throw sourceLocation.error("TextBlock title not found")
            }
            guard valueFound == title else {
                throw sourceLocation.error("TextBlock title is expected to be \(title), found \(valueFound) instead")
            }
        } else {
            do {
                _ = try self.find(viewWithAccessibilityIdentifier: A11y.title)
                throw sourceLocation.error("TextBlock title view is expected to be missing bot is was found")
            } catch {
                // do nothing, expcted behaviour
            }
        }
    
        guard let valueFound = try? self.find(viewWithAccessibilityIdentifier: A11y.text).text().string() else {
            throw sourceLocation.error("TextBlock text not found")
        }
        guard valueFound == text else {
            throw sourceLocation.error("TextBlock text is expected to be \(text), found \(valueFound) instead")
        }
    }
}

private typealias A11y = TextBlockViewA11y
