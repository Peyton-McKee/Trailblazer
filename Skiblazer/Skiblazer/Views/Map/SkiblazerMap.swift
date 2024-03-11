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
                            .image(.init(image: .init(resource: .intermediatePin), name: trail.id.uuidString))
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
                            .iconOffset([0, -20])
                            .iconColor(.init(report.type.color))
                            .textField(report.type.pointString)
                            .iconHaloColor(.init(report.type.color))
                            .iconHaloWidth(1)
                            .textColor(.init(.white))
                            .textHaloColor(.init(report.type.color))
                            .textHaloWidth(1)
                            .onTapGesture {
                                self.viewModel.onTrailReportTapped(report)
                            }
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
                .ornamentOptions(.init(scaleBar: .init(visibility: .hidden), compass: .init(visibility: .hidden)))
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
                } onSeeMoreDetailsPressed: {
                    self.viewModel.onSeeMoreDetailsPressed()
                }
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: self.$viewModel.showNoLongerThereView) {
                if let trailReport = self.viewModel.selectedTrailReport {
                    NoLongerThereView(trailReport: trailReport) { report in
                        self.viewModel.onNoLongerTherePressed(report)
                    } onCancelPressed: {
                        self.viewModel.onNoLongerThereCancelPressed()
                    }
                    .padding()
                    .presentationDetents([.fraction(0.15)])
                }
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
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
            .overlay(alignment: .topTrailing) {
                HStack(alignment: .top) {
                    if self.viewModel.routeInProgress {
                        GeometryContainer {
                            FullDirectionsView(route: self.viewModel.currentPath, showFullDirections: self.$viewModel.showFullDirectionsView)
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.combined(with: .move(edge: .top)),
                                        removal: .opacity.combined(with: .move(edge: .top))))
                                .padding()
                                .background(
                                    Color(.systemBackground)
                                        .clipShape(.rect(cornerRadius: 8))
                                        .shadow(color: .primary, radius: 5, y: 5))
                        }
                    }

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

                        Button {
                            self.viewModel.onRealTimeSelected()
                        } label: {
                            Image(systemName: SystemImageName.time.rawValue)
                        }
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(.buttonBorder)

                        Button {
                            withAnimation {
                                self.viewport = Viewport.followPuck(zoom: 14)
                            }
                        } label: {
                            Image(systemName: SystemImageName.location.rawValue)
                        }
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(.buttonBorder)
                        
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
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }

    var clusterOptions: ClusterOptions {
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

        return ClusterOptions(
            circleColor: .constant(.init(.clear)),
            textColor: .constant(.init(.clear)),
            clusterRadius: 20,
            clusterMaxZoom: 100,
            clusterProperties: clusterProperties)
    }
}
