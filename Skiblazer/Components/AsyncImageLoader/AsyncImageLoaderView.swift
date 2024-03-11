//
//  AsyncImageLoaderView.swift
//  Snowport
//
//  Created by Peyton McKee on 1/8/24.
//

import SwiftUI

struct AsyncImageLoaderView: View, Equatable {
    static func == (lhs: AsyncImageLoaderView, rhs: AsyncImageLoaderView) -> Bool {
        return lhs.viewModel.oauthToken == rhs.viewModel.oauthToken
    }
    
    @ObservedObject var viewModel: AsyncImageLoaderModel
    var aspectRatio: ContentMode = .fit

    init(viewModel: AsyncImageLoaderModel, aspectRatio: ContentMode = .fit) {
        self.viewModel = viewModel
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        AsyncContentView(source: self.viewModel) { props in
            GeometryReader { geometry in
                Image(uiImage: props.image)
                    .resizable()
                    .aspectRatio(contentMode: self.aspectRatio)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .clipped()
                    .contentShape(.rect)
            }
        }
    }
}

#Preview {
    AsyncImageLoaderView(viewModel: .init(image: .init(systemName: SystemImageName.briefcase.rawValue)!))
}
