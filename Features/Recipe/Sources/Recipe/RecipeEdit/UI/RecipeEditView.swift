//
//  RecipeEditView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//
import SwiftUI



struct RecipeEditView: View {
    @Bindable var dataModel: RecipeDraftModel

    var body: some View {
        // let _ = Self._printChanges()
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HeaderEditView(value: $dataModel.title)

                Divider()
                
                IngredientsEditBlock(items: $dataModel.ingredients)
            }
        }
    }
}

#Preview("Заполненная форма") {
    let dataModel = RecipeDraftModel()
    dataModel.title = "Котлета по-киевски"
    

    return RecipeEditViewPreviewWrapper(
        dataModel: dataModel
    )
}

private struct RecipeEditViewPreviewWrapper: View {
    @State var dataModel: RecipeDraftModel
    
    var body: some View {
        RecipeEditView(dataModel: dataModel)
    }
}
