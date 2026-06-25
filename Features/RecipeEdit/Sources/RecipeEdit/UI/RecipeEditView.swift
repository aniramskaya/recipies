//
//  RecipeEditView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//
import SwiftUI



struct RecipeEditView: View {
    @ObservedObject var dataModel: RecipeDataModel
    @ObservedObject var viewModel: RecipeEditViewModel

    var body: some View {
        // let _ = Self._printChanges()
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                formField(title: "Название") {
                    TextField("Введите название", text: $dataModel.name)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier(RecipeEditA11y.nameField)
                } error: {
                    viewModel.errors.name
                } errorIdentifier: {
                    RecipeEditA11y.nameError
                }

                formField(title: "Длительность (мин)") {
                    TextField("Введите длительность", text: $dataModel.cookingTime)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier(RecipeEditA11y.cookingTimeField)
                } error: {
                    viewModel.errors.cookingTime
                } errorIdentifier: {
                    RecipeEditA11y.cookingTimeError
                }

                formField(title: "Сложность (1–5)") {
                    Stepper(
                        value: $dataModel.complexity,
                        in: 1...5,
                        label: {
                            Text("\(dataModel.complexity)")
                                .accessibilityIdentifier(RecipeEditA11y.complexityValue)
                        }
                    )
                    .accessibilityIdentifier(RecipeEditA11y.complexityField)
                } error: {
                    viewModel.errors.complexity
                } errorIdentifier: {
                    RecipeEditA11y.complexityError
                }

                Button(action: viewModel.onSave) {
                    Group {
                        if case .saving = viewModel.savingState {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text("Сохранить")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(viewModel.savingState == .saving)
                .accessibilityIdentifier(RecipeEditA11y.saveButton)
                .padding(.top, 8)
            }
            .padding()
        }
        .overlay {
            SavingOverlayView(
                savingState: viewModel.savingState,
                onClose: viewModel.onClose
            )
        }
        .onDisappear(perform: viewModel.onDisappear)
    }

    @ViewBuilder
    private func formField<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content,
        error: () -> String?,
        errorIdentifier: () -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            content()
            if let errorText = error() {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(.red)
                    .accessibilityIdentifier(errorIdentifier())
            }
        }
    }
}

#Preview("Заполненная форма") {
    let dataModel = RecipeDataModel()
    dataModel.name = "Котлета по-киевски"
    dataModel.cookingTime = "35"
    dataModel.complexity = 3
    
    let viewModel = RecipeEditViewModel()

    return RecipeEditViewPreviewWrapper(
        dataModel: dataModel,
        viewModel: viewModel
    )
}

#Preview("Сохранение") {
    let dataModel = RecipeDataModel()
    dataModel.name = "Котлета по-киевски"
    dataModel.cookingTime = "35"
    dataModel.complexity = 3
    
    let viewModel = RecipeEditViewModel()
    viewModel.savingState = .saving

    return RecipeEditViewPreviewWrapper(
        dataModel: dataModel,
        viewModel: viewModel
    )
}

#Preview("Ошибки валидации") {
    let dataModel = RecipeDataModel()
    dataModel.name = ""
    dataModel.cookingTime = ""
    dataModel.complexity = 1
    
    let viewModel = RecipeEditViewModel()
    viewModel.errors = .init(
        name: "Поле обязательно",
        cookingTime: "Поле обязательно",
        complexity: nil
    )
    viewModel.savingState = .saving

    
    return RecipeEditViewPreviewWrapper(
        dataModel: dataModel,
        viewModel: viewModel
    )
}

private struct RecipeEditViewPreviewWrapper: View {
    @State var dataModel: RecipeDataModel
    @State var viewModel: RecipeEditViewModel
    
    var body: some View {
        RecipeEditView(dataModel: dataModel, viewModel: viewModel)
    }
}
