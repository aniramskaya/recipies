//
//  hostInWindow.swift
//  recipes
//
//  Created by Марина Чемезова on 14.01.2026.
//

import UIKit
import SwiftUI

@MainActor
public func hostInWindow<V: View>(_ view: V, size: CGSize = .init(width: 320, height: 640)) -> (UIWindow, UIHostingController<V>) {
    let vc = UIHostingController(rootView: view)
    // 'init(frame:)' was deprecated in iOS 26.0: Use init(windowScene:) instead.
    
    let window = {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return UIWindow(windowScene: scene)
        } else {
            return UIWindow(frame: CGRect(origin: .zero, size: size))
        }
    }()
    window.rootViewController = vc
    window.makeKeyAndVisible()

    vc.loadViewIfNeeded()
    vc.view.setNeedsLayout()
    vc.view.layoutIfNeeded()

    return (window, vc)
}
