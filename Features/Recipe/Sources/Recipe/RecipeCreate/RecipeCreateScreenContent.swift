//
//  RecipeCreateScreenContent.swift
//  Recipe
//
//  Created by Марина Чемезова on 25.10.2026.
//

import SwiftUI
import RecipeUIKit

struct RecipeCreateScreenContent: View {
    let viewModel: RecipeEditViewModel
    @State private var showDeleteConfirmation = false

    var body: some View {
        RecipeEditView(
            dataModel: viewModel.model,
            fieldErrors: viewModel.fieldErrors,
            isSaving: viewModel.isSaving
        )
        .task {
            await viewModel.onAppearTask()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Button("Готово", action: viewModel.onSubmitTapped)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Text("Удалить черновик рецепта")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .padding(.horizontal, 20)
        }
        .confirmationDialog(
            "Удалить черновик?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Удалить черновик рецепта", role: .destructive, action: viewModel.onDeleteTapped)
        }
    }
}
