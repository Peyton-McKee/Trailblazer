//
//  Point.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/5/24.
//

import CoreLocation

struct Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.coordinate == rhs.coordinate && lhs.title == rhs.title
    }

    var coordinate: CLLocationCoordinate2D
    var title: String
    var difficulty: Difficulty
    var trailReport: TrailReport?
}
