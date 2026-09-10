//
//  CookingEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI

struct RecipeCookingEditView: View {
    @Binding var steps: [RecipeStepDraftModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: RecipeStyles.Spacing.medium) {
            Text(.cookingBlockHeader)
                .font(.title2)
                .bold()
                .accessibilityAddTraits([.isHeader])
                .accessibilityHeading(.h1)

            ForEach(Array($steps.enumerated()), id: \.element.id) { index, item in
                RecipeStepEditView(step: UInt(index + 1), model: item) {
                    remove(at: index)
                }
            }
            
            AddElementButton(
                action: add,
                title: .cookingStepAdd,
                accessibilityIdentifier: A11y.addButton
            )
        }
        .padding(RecipeStyles.Padding.default)
        .accessibilityIdentifier(A11y.component)
    }
    
    func remove(at index: Int) {
        withAnimation(.spring(duration: 0.3)) {
            let _ = steps.remove(at: index)
        }
    }
    
    func add() {
        withAnimation(.spring(duration: 0.3)) {
            steps.append(.init(id: .init(), title: "", imageSource: nil, text: ""))
        }
    }
}

private typealias A11y = RecipeCookingEditViewA11y

enum RecipeCookingEditViewA11y {
    static let component = "RecipeCookingEditView"
    static let addButton = "RecipeCookingEditViewAddButton"
}

#Preview {
    @Previewable @State var steps: [RecipeStepDraftModel] = [
        .init(id: .init(), title: "Маринование", imageSource: nil, text: "Нарежьте куриные бёдра на кусочки 4–5 см. Смешайте с йогуртом, чесноком, имбирём и специями маринада. Накройте и оставьте в холодильнике минимум на 1 час."),
        .init(id: .init(), title: "", imageSource: nil, text: "")
    ]
    
    ScrollView {
        RecipeCookingEditView(steps: $steps)
    }
}
