//
//  PhotoPlaceholder.swift
//  Recipe
//
//  Created by Марина Чемезова on 04.09.2026.
//

import SwiftUI
import RecipeUIKit

struct PhotoPlaceholder: View {
    let onAdd: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: RecipeStyles.Radius.small)
            .fill(RecipeUIKitAssets.Color.fieldBackground)
            .frame(height: 60)
            .overlay {
                Button(action: onAdd) {
                    Image(systemName: "plus.circle")
                        .frame(width: 24, height: 24)
                    Text(.addPhoto)
                }
                .foregroundStyle(Color.orange)
            }
    }
}

#Preview {
    PhotoPlaceholder(onAdd: {})
}
