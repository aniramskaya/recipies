//
//  ErrorView.swift
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI

public struct ErrorView: View {
    public let error: String
    public let onRetry: () -> Void
    
    public init(error: String, onRetry: @escaping () -> Void) {
        self.error = error
        self.onRetry = onRetry
    }
    
    public var body: some View {
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

public struct ErrorViewA11y {
    public static let component = "ErrorView"
    public static let errorText = "ErrorText"
    public static let retryButton = "RetryButton"
}

#Preview {
    ErrorView(error: "Не удалось загрузить") { }
}
