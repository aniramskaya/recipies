import SwiftUI

struct EditRecipeView: View {
    let data: EditRecipeFormData
    let errors: EditRecipeFormErrors
    let onSave: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                formField(title: "Название") {
                    TextField("Введите название", text: .constant(data.name))
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier(EditRecipeA11y.nameField)
                } error: {
                    errors.name
                } errorIdentifier: {
                    EditRecipeA11y.nameError
                }

                formField(title: "Длительность (мин)") {
                    TextField("Введите длительность", text: .constant(data.cookingTime))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier(EditRecipeA11y.cookingTimeField)
                } error: {
                    errors.cookingTime
                } errorIdentifier: {
                    EditRecipeA11y.cookingTimeError
                }

                formField(title: "Сложность (1–5)") {
                    Stepper(
                        value: .constant(data.complexity),
                        in: 1...5,
                        label: {
                            Text("\(data.complexity)")
                                .accessibilityIdentifier(EditRecipeA11y.complexityValue)
                        }
                    )
                    .accessibilityIdentifier(EditRecipeA11y.complexityField)
                } error: {
                    errors.complexity
                } errorIdentifier: {
                    EditRecipeA11y.complexityError
                }

                Button(action: onSave) {
                    Text("Сохранить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .accessibilityIdentifier(EditRecipeA11y.saveButton)
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
    EditRecipeView(
        data: EditRecipeFormData(name: "Котлета по-киевски", cookingTime: "35", complexity: 3),
        errors: .none,
        onSave: {}
    )
}

#Preview("Ошибки валидации") {
    EditRecipeView(
        data: .empty,
        errors: EditRecipeFormErrors(
            name: "Поле обязательно",
            cookingTime: "Поле обязательно",
            complexity: nil
        ),
        onSave: {}
    )
}
