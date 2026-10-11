//
//  TextBlockOptionalEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI

struct TextBlockOptionalEditView: View {
    @Binding var model: TextBlockDraftModel?

    var body: some View {
        if model != nil {
            TextBlockEditView(
                model: $model.withDefault(.init(title: "", text: "")),
                onRemove: { model = nil }
            )
        } else {
            TextBlockAddView {
                model = .init(title: "", text: "")
            }
        }
    }
}

#Preview("Filled") {
    @Previewable @State var model: TextBlockDraftModel? = .init(title: "Соус", text: "Смешать все ингредиенты")
    TextBlockOptionalEditView(model: $model)
}

#Preview("Empty") {
    @Previewable @State var model: TextBlockDraftModel? = nil
    TextBlockOptionalEditView(model: $model)
}
