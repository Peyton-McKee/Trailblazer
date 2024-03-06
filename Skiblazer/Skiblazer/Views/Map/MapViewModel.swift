//
//  MapViewModel.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct MapProps {}

class MapViewModel: LoadableObject {
    @Published var state: LoadingState<MapProps> = .idle
    @Published var graph: EdgeWeightedDigraph<Feature> = .init()

    @Published var trailsToDisplay: [Trail] = []

    @ObservedObject var mapInterpreter = MapInterpreter.shared

    var map: Map

    init(map: Map) {
        self.map = map
    }

    func load() {
        self.transitionState(.loading)
        Task {
            do {
                let map = try await APIHandler.getMapInfo(self.map)
                try await self.mapInterpreter.createMap(map: map)
                DispatchQueue.main.async {
                    self.pointsToDisplay = self.mapInterpreter.difficultyGraph.vertices.map { $0.value }
                    return self.load(.init())
                }
            } catch {
                self.fail(error, .init())
            }
        }
    }

    func onPolylineClicked(_ point: Point) {}
}
