
//
//  LoadingView.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(error)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier(ErrorViewA11y.errorText)
            Button {
                onRetry()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Повторить")
                }
                .padding(.vertical)
            }
            .accessibilityIdentifier(ErrorViewA11y.retryButton)
        }
        .accessibilityIdentifier(ErrorViewA11y.component)
    }
}

struct ErrorViewA11y {
    static let component = "ErrorView"
    static let errorText = "ErrorText"
    static let retryButton = "RetryButton"
}

#Preview {
    ErrorView(error: "Не удалось загрузить") { }
}
