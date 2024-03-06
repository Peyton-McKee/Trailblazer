//
//  Trail.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/5/24.
//

import CoreLocation

struct Trail: Equatable {
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        return lhs.title == rhs.title && lhs.difficulty == rhs.difficulty && lhs.coordinates == rhs.coordinates
    }

    var title: String
    var difficulty: Difficulty
    var coordinates: [CLLocationCoordinate2D]
}
