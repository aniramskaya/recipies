//
//  TextBlockView+DSL.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//

import Testing
import ViewInspector
import TestHelpers
@testable import RecipeEdit

extension InspectableView where View == ViewType.View<TextBlockView> {
    @MainActor
    func assertIsDisplaying(title: String?, text: String) throws {
        if let title {
            let valueFound = try self.find(viewWithAccessibilityIdentifier: A11y.title).text().string()
            guard valueFound == title else {
                throw TestError(reason: "TextBlock title is expected to be \(title), found \(valueFound) instead")
            }
        } else {
            do {
                _ = try self.find(viewWithAccessibilityIdentifier: A11y.title)
                throw TestError(reason: "TextBlock title view is expected to be missing bot is was found")
            } catch {
                // do nothing, expcted behaviour
            }
        }
    
        let valueFound = try self.find(viewWithAccessibilityIdentifier: A11y.text).text().string()
        guard valueFound == text else {
            throw TestError(reason: "TextBlock text is expected to be \(text), found \(valueFound) instead")
        }
    }
}

private typealias A11y = TextBlockViewA11y
