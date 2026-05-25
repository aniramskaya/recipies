//
//  ResourceLoadingView.swift
//  RecipeUIKit
//
//  Created by Марина Чемезова on 25.05.2026.
//

import SwiftUI

public enum ResourceLoadState<Resource> {
    case loading
    case failed(Error)
    case loaded(Resource)
}

public struct ResourceLoadingView<Resource, Loading: View, Failure: View, Content: View>: View {
    let state: ResourceLoadState<Resource>
    @ViewBuilder let loading: () -> Loading
    @ViewBuilder let failure: (Error) -> Failure
    @ViewBuilder let content: (Resource) -> Content
    
    public init(
        state: ResourceLoadState<Resource>,
        loading: @escaping () -> Loading,
        failure: @escaping (Error) -> Failure,
        content: @escaping (Resource) -> Content
    ) {
        self.state = state
        self.loading = loading
        self.failure = failure
        self.content = content
    }

    public var body: some View {
        switch state {
        case .loading:
            loading()
        case .loaded(let resource):
            content(resource)
        case .failed(let error):
            failure(error)
        }
    }
}
