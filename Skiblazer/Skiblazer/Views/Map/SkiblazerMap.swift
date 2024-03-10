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
            MapReader { _ in
                MapboxMaps.Map(viewport: self.$viewport) {
                    PolylineAnnotationGroup(self.viewModel.trailsToDisplay) { trail in
                        PolylineAnnotation(lineCoordinates: trail.coordinates)
                            .lineColor(.init(trail.color))
                            .lineWidth(self.lineWidth)
                    }

                    PointAnnotationGroup(self.viewModel.trailsToDisplay) { trail in
                        PointAnnotation(coordinate: trail.firstPoint.coordinate)
                            .image(named: "intermediate-pin")
                            .iconOffset([0, -20])
                            .iconColor(.init(trail.color))
                            .textField("\(trail.title)")
                            .iconHaloColor(.init(trail.color))
                            .iconHaloWidth(1)
                            .textColor(.init(.white))
                            .textHaloColor(.init(trail.color))
                            .textHaloWidth(1)
                    }
                    .clusterOptions(clusterOptions)

                    PointAnnotationGroup(self.viewModel.trailReportsToDisplay) { report in
                        PointAnnotation(coordinate: .init(latitude: report.latitude, longitude: report.longitude))
                            .image(.init(image: .init(resource: .intermediatePin), name: report.id))
                            .iconOffset([0, -20])
                            .iconColor(.init(report.type.color))
                            .textField(report.type.pointString)
                            .iconHaloColor(.init(report.type.color))
                            .iconHaloWidth(1)
                            .textColor(.init(.white))
                            .textHaloColor(.init(report.type.color))
                            .textHaloWidth(1)
                    }
                    .clusterOptions(clusterOptions)

                    Puck2D()
                        .showsAccuracyRing(true)
                }
                .onMapTapGesture { info in
                    self.viewModel.onMapTap(info.coordinate)
                }
                .onMapLongPressGesture { info in
                    self.viewModel.onMapLongPress(info.coordinate)
                }
                .mapStyle(.satellite)
                .cameraBounds(self.bounds)
            }
            .sheet(isPresented: self.$viewModel.showTrailReportSelector) {
                TrailReportSelector { report in
                    self.viewModel.onTrailReportTypeSelected(report)
                }
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: self.$viewModel.showSampleRouteView) {
                RouteSampleView(trails: self.viewModel.trailsToDisplay, trailReports: self.viewModel.trailReportsToDisplay) {
                    self.viewModel.onLetsGoPressed()
                }
                .presentationDetents([.fraction(0.3)])
            }
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
            .overlay(alignment: .topTrailing) {
                VStack {
                    Button {
                        self.viewModel.onTrailSelectorButtonPressed()
                    } label: {
                        Image(systemName: SystemImageName.search.rawValue)
                    }
                    .foregroundStyle(.primary)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(.buttonBorder)
                    .sheet(isPresented: self.$viewModel.showTrailSelector) {
                        TrailSelectorView(trails: self.viewModel.totalTrails) {
                            self.viewModel.onTrailSelected($0)
                        }
                    }

                    if self.viewModel.routeInProgress {
                        Button {
                            self.viewModel.cancelRoute()
                        } label: {
                            Image(systemName: SystemImageName.close.rawValue)
                        }
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(.buttonBorder)
                    }

                    Button {
                        self.viewModel.onRealTimeSelected()
                    } label: {
                        Image(systemName: SystemImageName.time.rawValue)
                    }
                    .foregroundStyle(.primary)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(.buttonBorder)
                }
                .padding()
            }
        }
    }

    var clusterOptions: ClusterOptions {
        let circleRadiusExpression = Exp(.step) {
            Exp(.get) { "point_count" }
            25
            5
            10
        }

        let circleColorExpression = Exp(.step) {
            Exp(.get) { "point_count" }
            UIColor.yellow
            5
            UIColor.green
            10
            UIColor.red
        }

        // Create expression to get the total count of annotations in a cluster
        let sumExpression = Exp {
            Exp(.sum) {
                Exp(.accumulated)
                Exp(.get) { "sum" }
            }
            1
        }

        // Create a cluster property to add to each cluster
        let clusterProperties: [String: Expression] = [
            "sum": sumExpression
        ]

        let textFieldExpression = Exp(.switchCase) {
            Exp(.has) { "point_count" }
            Exp(.concat) {
                Exp(.string) { "Count:\n" }
                Exp(.get) { "sum" }
            }
            Exp(.string) { "" }
        }

        return ClusterOptions(
            //            circleRadius: .expression(circleRadiusExpression),
//            circleColor: .expression(circleColorExpression),
//            textColor: .constant(StyleColor(.black)),
//            textField: .expression(textFieldExpression),
            circleColor: .constant(.init(.clear)),
            textColor: .constant(.init(.clear)),
            clusterRadius: 20,
            clusterMaxZoom: 100,
            clusterProperties: clusterProperties
        )
    }
}