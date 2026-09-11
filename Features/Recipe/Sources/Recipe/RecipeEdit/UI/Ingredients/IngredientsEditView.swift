//
//  IngredientsEditView.swift
//  Recipe
//
//  Created by Марина Чемезова on 07.08.2026.
//

import SwiftUI

struct IngredientsEditView: View {
    @Binding var ingredients: [IngredientDraftModel]
    let lastAddedIngredientId: UUID?

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
                    onDelete: { delete(item: item.wrappedValue) },
                    onMoveUp: { moveUp(id: item.wrappedValue.id )},
                    onMoveDown: { moveDown(id: item.wrappedValue.id )},
                    requestAccessibilityFocus: item.wrappedValue.id == lastAddedIngredientId
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
                    guard let draggingId else {
                        initDraggingIfNeeded(dragValue: value)
                        return
                    }
                    updateVisualOffsets(dragValue: value, draggingId: draggingId)
                }
                .onEnded { _ in
                    commitReorder()
                }
        )
    }
    
    private func initDraggingIfNeeded(dragValue: DragGesture.Value) {
        guard
            let touched = initialRectForTouch(at: dragValue.startLocation),
            let startIndex = ingredients.firstIndex(where: { $0.id == touched.key })
        else { return }
        draggingId = touched.key
        dragStartIndex = startIndex
        targetIndex = dragStartIndex
        fingerOffsetFromMidY = dragValue.startLocation.y - touched.value.midY
        initialCellRects = cellRects
    }
    
    private func updateVisualOffsets(dragValue: DragGesture.Value, draggingId: UUID) {
        guard let draggingCellMidY = initialCellRects[draggingId]?.midY else { return }

        dragOffset = dragValue.location.y - fingerOffsetFromMidY - draggingCellMidY

        let otherRects = cellRects
            .filter { $0.key != draggingId }
            .map(\.value)
        
        withAnimation(.spring(duration: 0.3)) {
            targetIndex = otherRects.count(where: { $0.midY <= dragValue.location.y })
        }
    }
    
    private func commitReorder() {
        guard let draggedId = draggingId else { return }

        withAnimation(.spring(duration: 0.3)) {
            dragOffset = ingredients[0..<targetIndex].reduce(0, { partialResult, item in
                partialResult + (cellRects[item.id]?.height ?? 0) + spacing
            }) - (initialCellRects[draggedId]?.minY ?? 0)
        } completion: {
            if dragStartIndex != targetIndex {
                let toOffset = dragStartIndex < targetIndex ? targetIndex + 1 : targetIndex
                ingredients.move(fromOffsets: [dragStartIndex], toOffset: toOffset)
            }
            draggingId = nil
            dragOffset = 0
            dragStartIndex = 0
            targetIndex = 0
            fingerOffsetFromMidY = 0
            initialCellRects = [:]
        }
    }
    
    private func moveUp(id: UUID) {
        guard
            let index = ingredients.firstIndex(where: { $0.id == id }),
            index > 0
        else { return }
        ingredients.move(fromOffsets: [index], toOffset: index - 1)
    }
    
    private func moveDown(id: UUID) {
        guard
            let index = ingredients.firstIndex(where: { $0.id == id }),
            index + 1 < ingredients.count
        else { return }
        ingredients.move(fromOffsets: [index], toOffset: index + 2)
    }

    private func visualOffset(for id: UUID) -> CGFloat {
        guard let draggingId else { return 0 }

        if id == draggingId {
            return dragOffset
        }

        guard let currentIndex = ingredients.firstIndex(where: { $0.id == id }) else { return 0 }
        let offset = (initialCellRects[draggingId]?.height ?? 0) + spacing

        if dragStartIndex < targetIndex {
            if currentIndex > dragStartIndex && currentIndex <= targetIndex {
                return -offset
            }
        } else if dragStartIndex > targetIndex {
            if currentIndex >= targetIndex && currentIndex < dragStartIndex {
                return offset
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
        withAnimation(.spring(duration: 0.3)) {
            ingredients.removeAll { $0.id == item.id }
        }
    }
}

#Preview {
    @Previewable @State var items: [IngredientDraftModel] = [
        .init(id: UUID(), name: "400 мл воды"),
        .init(id: UUID(), name: "1 пакетик чая"),
    ]

    IngredientsEditView(ingredients: $items, lastAddedIngredientId: nil)
}
