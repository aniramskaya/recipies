//
//  IngredientsEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct IngredientsEditView: View {
    @Binding var ingredients: [IngredientDraftModel]

    private let spacing = RecipeStyles.Spacing.xSmall

    @State private var draggingId: UUID? = nil
    @State private var dragStartIndex: Int = 0
    @State private var targetIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var fingerOffsetFromMidY: CGFloat = 0
    @State private var cellRects: [UUID: CGRect] = [:]
    @State private var handleRects: [UUID: CGRect] = [:]
    @State private var initialCellRects: [UUID: CGRect] = [:]

    var body: some View {
        VStack(spacing: spacing) {
            ForEach($ingredients, id: \.id) { item in
                IngredientEditView(
                    ingredient: item,
                    onDelete: { delete(item: item.wrappedValue) }
                ) {
                    DragHandleView(width: 16, lineHeight: 2, spacing: 3)
                        .padding(8)
                        .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .named("ingredientsList")) }) {
                            handleRects[item.id] = $0
                        }
                }
                .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .named("ingredientsList")) }) {
                    cellRects[item.id] = $0
                }
                .offset(y: draggingId == nil ? 0 : visualOffset(for: item.id))
                .zIndex(draggingId == item.id ? 1 : 0)
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: targetIndex) { _, _ in draggingId != nil }
        .coordinateSpace(.named("ingredientsList"))
        .contentShape(Rectangle())
        .gesture(
            DragGesture(coordinateSpace: .named("ingredientsList"))
                .onChanged { value in
                    if draggingId == nil {
                        guard let touched = initialRectForTouch(at: value.startLocation) else { return }
                        draggingId = touched.key
                        dragStartIndex = ingredients.firstIndex(where: { $0.id == touched.key })!
                        targetIndex = dragStartIndex
                        fingerOffsetFromMidY = value.startLocation.y - touched.value.midY
                        initialCellRects = cellRects
                    }

                    guard let id = draggingId,
                          let startRect = initialCellRects[id] else { return }

                    dragOffset = value.location.y - fingerOffsetFromMidY - startRect.midY

                    let sortedOtherRects = initialCellRects
                        .filter { $0.key != id }
                        .sorted { initialCellRects[$0.key]!.midY < initialCellRects[$1.key]!.midY }
                        .map(\.value)

                    withAnimation(.spring(duration: 0.3)) {
                        targetIndex = sortedOtherRects.reduce(0) { count, rect in
                            value.location.y < rect.midY ? count : count + 1
                        }
                    }
                    
                    print("targetIndex \(targetIndex)")
                }
                .onEnded { _ in
                    if let id = draggingId {
                        let currentIndex = ingredients.firstIndex(where: { $0.id == id })!
                        if currentIndex != targetIndex {
                            let toOffset = currentIndex < targetIndex ? targetIndex + 1 : targetIndex
                            ingredients.move(fromOffsets: [currentIndex], toOffset: toOffset)
                        }
                    }
//                    withAnimation(.spring(duration: 0.3)) {
                        draggingId = nil
                        dragOffset = 0
//                    }
                    dragStartIndex = 0
                    targetIndex = 0
                    fingerOffsetFromMidY = 0
                    initialCellRects = [:]
                }
        )
    }

    private func visualOffset(for id: UUID) -> CGFloat {
        guard draggingId != nil else { return 0 }

        if id == draggingId {
            return dragOffset
        }

        guard let currentIndex = ingredients.firstIndex(where: { $0.id == id }) else { return 0 }
        let step = (initialCellRects[draggingId!]?.height ?? 0) + spacing

        if dragStartIndex < targetIndex {
            if currentIndex > dragStartIndex && currentIndex <= targetIndex {
                return -step
            }
        } else if dragStartIndex > targetIndex {
            if currentIndex >= targetIndex && currentIndex < dragStartIndex {
                return step
            }
        }
        return 0
    }

    private func initialRectForTouch(at location: CGPoint) -> (key: UUID, value: CGRect)? {
        guard let handleEntry = handleRects.first(where: { $0.value.contains(location) }) else { return nil }
        guard let cellRect = cellRects[handleEntry.key] else { return nil }
        return (key: handleEntry.key, value: cellRect)
    }

    private func delete(item: IngredientDraftModel) {
        ingredients.removeAll { $0.id == item.id }
    }
}

#Preview {
    @Previewable @State var items: [IngredientDraftModel] = [
        .init(id: UUID(), name: "400 мл воды"),
        .init(id: UUID(), name: "1 пакетик чая"),
    ]

    IngredientsEditView(ingredients: $items)
}
