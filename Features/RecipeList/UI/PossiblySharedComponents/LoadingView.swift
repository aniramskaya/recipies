//
//  LoadingView.swift
//  RecipeList
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Загрузка...")
            ProgressView()
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(LoadingViewA11y.component)
    }
}

struct LoadingViewA11y {
    static let component = "LoadingView"
}

#Preview {
    LoadingView()
}
