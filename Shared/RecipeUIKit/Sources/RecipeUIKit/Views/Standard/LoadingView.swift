//
//  LoadingView.swift
//
//  Created by Марина Чемезова on 05.01.2026.
//

import SwiftUI

public struct LoadingView: View {
    public init(){}
    
    public var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Загрузка...")
            ProgressView()
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(LoadingViewA11y.component)
    }
}

public struct LoadingViewA11y {
    public static let component = "LoadingView"
}

#Preview {
    LoadingView()
}
