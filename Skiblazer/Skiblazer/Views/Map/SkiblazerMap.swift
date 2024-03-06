//
//  MapView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct SkiblazerMap: View {
    @ObservedObject var viewModel: MapViewModel

    @State var viewport = Viewport.camera()
    var lineWidth: Double = 3
    
    var body: some View {
        AsyncContentView(source: self.viewModel) { _ in
            MapboxMaps.Map(viewport: self.$viewport) {
                PolylineAnnotationGroup(viewModel.pointsToDisplay) { point in
                    PolylineAnnotation(lineCoordinates: feature.geometry.coordinates)
                        .lineColor(.init(.green))
                        .lineWidth(self.lineWidth)
                        .onTapGesture {
                            self.viewModel.onPolylineClicked(feature)
                        }
                }
            }
            .mapStyle(.satellite)
            .onAppear {
                if let firstLiftCoord = props.lifts.features.first?.geometry.coordinates.first {
                    self.viewport = .camera(center: firstLiftCoord, zoom: 12)
                }
            }
            .ignoresSafeArea()
        }
    }
}
