//
//  RecipeListImage.swift
//  recipes
//
//  Created by Марина Чемезова on 23.12.2025.
//

import SwiftUI
import UIKit

enum RecipeImageSource {
    case remote(URL)
    case asset(String)     // имя ассета
    case system(String)    // SF Symbol
    case uiImage(UIImage)  // для тестов/генерации
}

struct RecipeImageView: View {
    let source: RecipeImageSource

    var body: some View {
        switch source {
        case .remote(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFill()

        case .system(let name):
            Image(systemName: name)
                .resizable()
                .scaledToFill()

        case .uiImage(let img):
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
        }
    }
}
