//
//  NotesCheckbox.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//
import SwiftUI
import RecipeUIKit

struct NotesCheckbox: View {
    private static let size: CGFloat = 24
    private static let borderColor = Color(.separator)
    private static let borderWidth: CGFloat = 1.5
    private static let checkLineWidth: CGFloat = 2

    let isOn: Bool
    
    var body: some View {
        if isOn {
            Circle()
                .fill(RecipeUIKitAssets.Color.iconPrimary)
                .overlay(content: {
                    Check()
                        .stroke(.white, lineWidth: Self.checkLineWidth)
                })
                .frame(width: Self.size, height: Self.size)
        } else {
            Circle()
                .strokeBorder(Self.borderColor, lineWidth: Self.borderWidth)
                .frame(width: Self.size, height: Self.size)
        }
    }
}

private struct Check: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .init(x: rect.midX - 5, y: rect.midY))
        path.addLine(to: .init(x: rect.midX - 1, y: rect.midY + 4))
        path.addLine(to: .init(x: rect.midX + 4, y: rect.midY - 5))
        
        return path
    }
}


#Preview {
    NotesCheckbox(isOn: true)
    NotesCheckbox(isOn: false)
}

