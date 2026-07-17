//
//  RecipeHeaderView.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 17.07.2026.
//
import SwiftUI
import RecipeUIKit

struct RecipeHeaderViewModel {
    let imageSource: RecipeImageSource
    let cookingTimeMins: Int
    let complexity: Int
}

struct RecipeHeaderView: View {
    let model: RecipeHeaderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ClampedHeightLayout(maxHeight: 260) {
                RecipeImageView(source: model.imageSource)
                    .accessibilityIdentifier(A11y.image)
            }
            
            HStack {
                CookingTimeView(minutes: model.cookingTimeMins)
                    .accessibilityIdentifier(A11y.cookingTime)
                Spacer()
                RecipeComplexityView(value: model.complexity)
                    .accessibilityIdentifier(A11y.complexity)
            }
            .padding(20)
        }
        .accessibilityIdentifier(A11y.component)
    }
}

private typealias A11y = RecipeHeaderViewA11y

enum RecipeHeaderViewA11y {
    static let component = "RecipeHeaderView"
    static let image = "RecipeHeaderImage"
    static let complexity = "RecipeHeaderComplexity"
    static let cookingTime = "RecipeHeaderCookingTime"
}

private struct ClampedHeightLayout: Layout {
    let maxHeight: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let subview = subviews.first else { return .zero }
        let width = proposal.width ?? 0
        let natural = subview.sizeThatFits(.init(width: width, height: nil))
        return CGSize(width: width, height: min(natural.height, maxHeight))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(
            at: bounds.origin,
            proposal: .init(width: bounds.width, height: nil)
        )
    }
}


#Preview {
    RecipeHeaderView(model: .init(
        imageSource: .uiImage(RecipeUIKitAssets.image(named: "kiev")!),
        cookingTimeMins: 45,
        complexity: 4
    ))
}
