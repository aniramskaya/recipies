//
//  RecipeEditView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//
import SwiftUI



struct RecipeEditView: View {
    @Bindable var dataModel: RecipeDraftModel
    @State private var showDeleteConfirmation = false
    var fieldErrors: [String: String] = [:]
    var isSaving: Bool = false
    var onDelete: () -> Void = { }
    

    var body: some View {
        // let _ = Self._printChanges()
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HeaderEditView(
                    value: $dataModel.title,
                    fieldErrors: fieldErrors
                )
                Divider()
                DescriptionEditView(
                    text: $dataModel.description
                )
                Divider()
                IngredientsEditBlock(items: $dataModel.ingredients)
                Divider()
                TextBlockOptionalEditView(
                    model: $dataModel.topTextBlock
                )
                Divider()
                RecipeCookingEditView(
                    steps: $dataModel.steps
                )
                Divider()
                TextBlockOptionalEditView(
                    model: $dataModel.bottomTextBlock
                )
                Divider()
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Text(.deleteRecipeDraftAction)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .padding(RecipeStyles.Padding.default)
            }
        }
        .confirmationDialog(
            .deleteRecipeDraftConfirmTitle,
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                .deleteRecipeDraftAction,
                role: .destructive,
                action: onDelete
            )
            Button(
                .cancel,
                role: .cancel,
                action: { showDeleteConfirmation = false }
            )
        }
        .scrollDismissesKeyboard(.interactively)
        .disabled(isSaving)
        .overlay {
            if isSaving {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(1.5)
                    }
                    .accessibilityIdentifier(RecipeEditA11y.savingOverlay)
            }
        }
    }
}

#Preview("Заполненная форма") {
    @Previewable @State var dataModel = RecipeDraftModel(
        id: UUID(),
        title: "Котлета по-киевски",
        description: "Котлеты по-киевски – любимое многими блюдо, которое не все берутся приготовить. Не стоит опасаться, что что-то не выйдет. Вооружившись этим рецептом, у вас непременно получатся аккуратные, а главное – вкусные котлеты из нежнейшего куриного мяса с восхитительным ароматом сливочного масла и зелени.",
        ingredients: [
            IngredientDraftModel(id: UUID(), name: "850 г куриного филе"),
            IngredientDraftModel(id: UUID(), name: "180 г сливочного масла (размягчённое)"),
            IngredientDraftModel(id: UUID(), name: "100 г муки"),
            IngredientDraftModel(id: UUID(), name: "200 г панировочных сухарей")
        ],
        topTextBlock: TextBlockDraftModel(title: "Title", text: "Маринуйте курицу не менее часа, лучше — ночь в холодильнике. Обжаривайте небольшими порциями, чтобы кусочки подрумянились."),
        steps: [
            RecipeStepDraftModel(
                id: UUID(),
                title: "Приготовление",
                imageSource: nil,
                text: "Маринуйте курицу не менее часа, лучше — ночь в холодильнике. Обжаривайте небольшими порциями, чтобы кусочки подрумянились."),
        ],
        bottomTextBlock: nil
    )

    return RecipeEditView(dataModel: dataModel)
}
