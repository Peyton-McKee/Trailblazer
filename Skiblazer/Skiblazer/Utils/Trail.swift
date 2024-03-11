//
//  Trail.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/5/24.
//

import CoreLocation
import SwiftUI

struct Trail: Equatable, Identifiable {
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        return lhs.title == rhs.title && lhs.difficulty == rhs.difficulty && lhs.coordinates == rhs.coordinates
    }

    var id = UUID()
    var title: String
    var difficulty: Difficulty
    var coordinates: [CLLocationCoordinate2D]

    var color: UIColor {
        switch self.difficulty {
        case .easy:
            return .Theme.easyColor
        case .intermediate:
            return .Theme.intermediateColor
        case .advanced:
            return .Theme.advancedColor
        case .expertsOnly:
            return .Theme.expertsOnlyColor
        case .lift:
            return .Theme.liftsColor
        case .terrainPark:
            return .Theme.terrainParksColor
        case .connector:
            return .Theme.easyColor
        }
    }

    var firstPoint: Point {
        return .init(coordinate: self.coordinates[0], title: self.title, difficulty: self.difficulty)
    }
}
