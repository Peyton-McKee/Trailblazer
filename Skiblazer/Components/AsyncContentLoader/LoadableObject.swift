//
//  LoadableObject.swift
//  Snowport
//
//  Created by Peyton McKee on 1/4/24.
//

import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get set }
    func load()
}

extension LoadableObject {
    func fail(_ error: Error, _ output: Output? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print(error)
            withAnimation {
                self.state = .failed(error, output)
            }
        }
    }

    func load(_ output: Output) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.state = .loaded(output)
            }
        }
    }

    func transitionState(_ newState: LoadingState<Output>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.state = newState
            }
        }
    }
}
