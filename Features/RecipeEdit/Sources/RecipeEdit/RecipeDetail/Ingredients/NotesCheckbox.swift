//
//  NotesCheckbox.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 04.07.2026.
//
import SwiftUI
import RecipeUIKit

struct NotesCheckbox: View {
    let SIZE: CGFloat = 24
    let BORDER_COLOR = Color(white: 0.77)
    let BORDER_WIDTH: CGFloat = 1.5
    let CHECK_LINE_WIDTH: CGFloat = 2

    let isOn: Bool
    
    var body: some View {
        if isOn {
            Circle()
                .fill(RecipeUIKitAssets.Color.iconPrimary)
                .overlay(content: {
                    Check()
                        .stroke(.white, lineWidth: CHECK_LINE_WIDTH)
                })
                .frame(width: SIZE, height: SIZE)
        } else {
            Circle()
                .strokeBorder(BORDER_COLOR, lineWidth: BORDER_WIDTH)
                .frame(width: SIZE, height: SIZE)
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

