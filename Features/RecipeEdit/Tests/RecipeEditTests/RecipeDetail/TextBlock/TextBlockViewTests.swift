//
//  TextBlockViewTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 14.07.2026.
//


import Testing
import ViewInspector
@testable import RecipeEdit
import Foundation

struct TextBlockViewTests {
    @MainActor
    @Test("Text block display full")
    func textBlockDisplayFull() throws {
        let sut = TextBlockView(model: textBlockFull)
        let inspectable = try sut.inspect().find(TextBlockView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(
                title: textBlockFull.title,
                text: textBlockFull.text
            )
        }
    }
    
    @MainActor
    @Test("Text block display compact")
    func textBlockDisplayCompact() throws {
        let sut = TextBlockView(model: textBlockCompact)
        let inspectable = try sut.inspect().find(TextBlockView.self)
        
        #expect(throws: Never.self) {
            try inspectable.assertIsDisplaying(
                title: textBlockCompact.title,
                text: textBlockCompact.text
            )
        }
    }
}

let textBlockFull = TextBlockViewModel(id: UUID(), text: "Text block text", title: "Text block title")
let textBlockCompact = TextBlockViewModel(id: UUID(), text: "Text block text", title: nil)
