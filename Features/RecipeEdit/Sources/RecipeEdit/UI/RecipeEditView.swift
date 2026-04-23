import SwiftUI

struct RecipeEditView: View {
    let data: RecipeEditFormData
    let errors: RecipeEditFormErrors
    let onSave: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                formField(title: "Название") {
                    TextField("Введите название", text: .constant(data.name))
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier(RecipeEditA11y.nameField)
                } error: {
                    errors.name
                } errorIdentifier: {
                    RecipeEditA11y.nameError
                }

                formField(title: "Длительность (мин)") {
                    TextField("Введите длительность", text: .constant(data.cookingTime))
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
                        value: .constant(data.complexity),
                        in: 1...5,
                        label: {
                            Text("\(data.complexity)")
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
                    Text("Сохранить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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
    RecipeEditView(
        data: RecipeEditFormData(name: "Котлета по-киевски", cookingTime: "35", complexity: 3),
        errors: .none,
        onSave: {}
    )
}

#Preview("Ошибки валидации") {
    RecipeEditView(
        data: .empty,
        errors: RecipeEditFormErrors(
            name: "Поле обязательно",
            cookingTime: "Поле обязательно",
            complexity: nil
        ),
        onSave: {}
    )
}
