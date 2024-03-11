//
//  MapSelectorViewModel.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct MapSelectorProps {
    var maps: [Map]
}

class MapSelectorViewModel: LoadableObject {
    @Published var state: LoadingState<MapSelectorProps> = .idle

    func load() {
        self.transitionState(.loading)
        Task {
            do {
                let maps = try await APIHandler.getAllMaps()
                self.load(.init(maps: maps))
            } catch {
                self.fail(error, .init(maps: []))
            }
        }
    }
}
