//
//  AsyncContentView.swift
//  Snowport
//
//  Created by Peyton McKee on 1/4/24.
//

import SwiftUI

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content
    @State var toast: Toast?

    var body: some View {
        Group {
            switch source.state {
            case .idle:
                Color.clear
                    .onAppear {
                        self.source.load()
                    }
            case .loading:
                LoadingIndicator()
            case .loadingAsyncImage:
                Image(systemName: SystemImageName.photo.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.4)
            case .failed(let error, let output):
                Group {
                    if let output = output {
                        self.content(output)
                    } else {
                        EmptyView()
                    }
                }
                .onAppear {
                    self.toast = .init(style: .error, message: error.localizedDescription)
                }
            case .loaded(let output):
                self.content(output)
            case .empty:
                EmptyView()
            }
        }
        .toastView(toast: self.$toast)
    }
}
