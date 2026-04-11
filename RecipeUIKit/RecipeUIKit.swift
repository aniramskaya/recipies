//
//  RecipeUIKit.swift
//  RecipeUIKit
//
//  Created by Марина Чемезова on 04.01.2026.
//

import Foundation
import UIKit
import SwiftUI

public enum RecipeListUIAssets {
    public static let bundle: Bundle = {
        Bundle(for: BundleToken.self)
    }()

    public static func image(named: String) -> UIImage? {
        .init(named: named, in: bundle, compatibleWith: nil)
    }

    public enum Color {
        public static var iconPrimary: SwiftUI.Color {
            SwiftUI.Color("icon.primary", bundle: RecipeListUIAssets.bundle)
        }
    }

    private final class BundleToken {}
}
