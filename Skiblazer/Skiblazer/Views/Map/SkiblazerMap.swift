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
    @State var bounds = CameraBoundsOptions()
    var lineWidth: Double = 3
    var radius = 0.1

    var body: some View {
        AsyncContentView(source: self.viewModel) { _ in
            MapboxMaps.Map(viewport: self.$viewport) {
                PolylineAnnotationGroup(self.viewModel.trailsToDisplay) { trail in
                    PolylineAnnotation(lineCoordinates: trail.coordinates)
                        .lineColor(.init(trail.color))
                        .lineWidth(self.lineWidth)
                        .onTapGesture {
                            self.viewModel.onPolylineClicked(trail)
                        }
                }
                
                Puck2D()
                    .showsAccuracyRing(true)
            }
            .mapStyle(.satellite)
            .cameraBounds(self.bounds)
            .onAppear {
                LocationManager.shared.requestWhenInUseAuthorization()
                LocationManager.shared.startUpdatingHeading()
                LocationManager.shared.startUpdatingLocation()
                if let firstLiftCoord = self.viewModel.trailsToDisplay.last?.coordinates.first {
                    self.viewport = .camera(center: firstLiftCoord, zoom: 12)
                    self.bounds = .init(bounds: .init(southwest: .init(latitude: firstLiftCoord.latitude + self.radius, longitude: firstLiftCoord.longitude - self.radius), northeast: .init(latitude: firstLiftCoord.latitude - self.radius, longitude: firstLiftCoord.longitude + self.radius)))
                }
            }
            .ignoresSafeArea()
        }
    }
}
