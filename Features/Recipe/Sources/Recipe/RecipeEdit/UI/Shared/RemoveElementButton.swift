//
//  RemoveElementButton.swift
//  Recipe
//
//  Created by Марина Чемезова on 10.09.2026.
//

import SwiftUI

struct RemoveElementButton: View {
    let action: () -> Void
    let title: LocalizedStringResource
    let accessibilityIdentifier: String
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Image(systemName: "minus.circle")
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(Color.red)
            .accessibilityIdentifier(accessibilityIdentifier)
        }
    }
}
