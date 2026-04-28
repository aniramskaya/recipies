import SwiftUI

struct RecipeEditView: View {
    @Binding var name: String
    @Binding var cookingTime: String
    @Binding var complexity: Int
    let errors: RecipeEditFormErrors
    let savingState: SavingState
    let onSave: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                formField(title: "Название") {
                    TextField("Введите название", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier(RecipeEditA11y.nameField)
                } error: {
                    errors.name
                } errorIdentifier: {
                    RecipeEditA11y.nameError
                }

                formField(title: "Длительность (мин)") {
                    TextField("Введите длительность", text: $cookingTime)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier(RecipeEditA11y.cookingTimeField)
                } error: {
                    errors.cookingTime
                } errorIdentifier: {
                    RecipeEditA11y.cookingTimeError
                }

                formField(title: "Сложность (1–5)") {
                    Stepper(
                        value: $complexity,
                        in: 1...5,
                        label: {
                            Text("\(complexity)")
                                .accessibilityIdentifier(RecipeEditA11y.complexityValue)
                        }
                    )
                    .accessibilityIdentifier(RecipeEditA11y.complexityField)
                } error: {
                    errors.complexity
                } errorIdentifier: {
                    RecipeEditA11y.complexityError
                }

                Button(action: onSave) {
                    Group {
                        if case .saving = savingState {
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
                .disabled(savingState == .saving)
                .accessibilityIdentifier(RecipeEditA11y.saveButton)
                .padding(.top, 8)
            }
            .padding()
        }
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
    RecipeEditViewPreviewWrapper(
        name: "Котлета по-киевски",
        cookingTime: "35",
        complexity: 3,
        errors: .none,
        savingState: .idle
    )
}

#Preview("Сохранение") {
    RecipeEditViewPreviewWrapper(
        name: "Котлета по-киевски",
        cookingTime: "35",
        complexity: 3,
        errors: .none,
        savingState: .saving
    )
}

#Preview("Ошибки валидации") {
    RecipeEditViewPreviewWrapper(
        name: "",
        cookingTime: "",
        complexity: 1,
        errors: RecipeEditFormErrors(
            name: "Поле обязательно",
            cookingTime: "Поле обязательно",
            complexity: nil
        ),
        savingState: .idle
    )
}

private struct RecipeEditViewPreviewWrapper: View {
    @State var name: String
    @State var cookingTime: String
    @State var complexity: Int
    let errors: RecipeEditFormErrors
    let savingState: SavingState

    var body: some View {
        RecipeEditView(name: $name, cookingTime: $cookingTime, complexity: $complexity, errors: errors, savingState: savingState, onSave: {})
    }
}
