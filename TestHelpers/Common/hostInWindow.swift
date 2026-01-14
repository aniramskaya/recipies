//
//  hostInWindow.swift
//  recipies
//
//  Created by Марина Чемезова on 14.01.2026.
//

import UIKit
import SwiftUI

public func hostInWindow<V: View>(_ view: V, size: CGSize = .init(width: 320, height: 640)) -> (UIWindow, UIHostingController<V>) {
    let vc = UIHostingController(rootView: view)
    let window = UIWindow(frame: CGRect(origin: .zero, size: size))
    window.rootViewController = vc
    window.makeKeyAndVisible()

    vc.loadViewIfNeeded()
    vc.view.setNeedsLayout()
    vc.view.layoutIfNeeded()

    return (window, vc)
}
