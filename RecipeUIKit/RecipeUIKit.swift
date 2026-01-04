//
//  RecipeUIKit.swift
//  RecipeUIKit
//
//  Created by Марина Чемезова on 04.01.2026.
//

import Foundation

public enum RecipeListUIAssets {
  public static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()

  private final class BundleToken {}
}
