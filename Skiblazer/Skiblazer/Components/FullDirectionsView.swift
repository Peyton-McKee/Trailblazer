//
//  FullDirectionsView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/9/24.
//

import CoreLocation
import SwiftUI

struct FullDirectionsView: View {
    var route: [Vertex<Point>]

    @Binding var showFullDirections: Bool

    var trails: [Trail] {
        var trails = [Trail]()

        for vertex in self.route {
            if var trail = trails.first(where: { $0.title == vertex.value.title }) {
                trail.coordinates.append(vertex.value.coordinate)
            } else {
                trails.append(Trail(title: vertex.value.title, difficulty: vertex.value.difficulty, coordinates: [vertex.value.coordinate]))
            }
        }
        return trails
    }

    var body: some View {
        Group {
            if self.showFullDirections {
                VStack {
                    if self.trails.count < 2 {
                        Text("Approaching Destination")
                    } else {
                        List {
                            ForEach(enumerating: 0 ..< (self.trails.count - Int(1))) { i in
                                if self.trails[i].coordinates.count > 1, let last = self.trails[i].coordinates.last {
                                    SingleDirectionView(
                                        direction: self.determineDirection(
                                            p1: self.trails[i].coordinates[self.trails[i].coordinates.count - 2],
                                            p2: last,
                                            p3: self.trails[i + 1].firstPoint.coordinate
                                        ),
                                        upcomingPoint: self.trails[i + 1].firstPoint,
                                        currentLocation: self.route[i].value
                                    )
                                } else {
                                    SingleDirectionView(
                                        direction: .straight,
                                        upcomingPoint: self.trails[i + 1].firstPoint,
                                        currentLocation: self.route[i].value
                                    )
                                }
                            }
                        }
                    }

                    SkiblazerButton("Close") {
                        withAnimation {
                            self.showFullDirections.toggle()
                        }
                    }
                }
            } else if self.trails.count > 1 {
                Group {
                    if self.trails[0].coordinates.count > 1, let last = self.trails[0].coordinates.last {
                        SingleDirectionView(
                            direction: self.determineDirection(
                                p1: self.trails[0].coordinates[self.trails[0].coordinates.count - 2],
                                p2: last,
                                p3: self.trails[1].firstPoint.coordinate
                            ),
                            upcomingPoint: self.trails[1].firstPoint,
                            currentLocation: self.route[0].value
                        )
                    } else {
                        SingleDirectionView(
                            direction: .straight,
                            upcomingPoint: self.trails[1].firstPoint,
                            currentLocation: self.route[0].value
                        )
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.showFullDirections.toggle()
                    }
                }
            }
        }
    }

    func determineDirection(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D, p3: CLLocationCoordinate2D) -> Direction {
        let val = (p2.longitude - p1.longitude) * (p3.latitude - p2.latitude) - (p2.latitude - p1.latitude) * (p3.longitude - p2.longitude)
        if val == 0 {
            return .straight // Points are collinear
        } else if val > 0 {
            return .right // Clockwise orientation
        } else {
            return .left // Counterclockwise orientation
        }
    }

    func determineDirection(p1: CLLocation, p2: CLLocation, p3: CLLocation) -> Direction {
        let val = (p2.coordinate.longitude - p1.coordinate.longitude) * (p3.coordinate.latitude - p2.coordinate.latitude) - (p2.coordinate.latitude - p1.coordinate.latitude) * (p3.coordinate.longitude - p2.coordinate.longitude)
        if val == 0 {
            return .straight // Points are collinear
        } else if val > 0 {
            return .right // Clockwise orientation
        } else {
            return .left // Counterclockwise orientation
        }
    }
}
