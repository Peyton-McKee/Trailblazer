//
//  MapConnector.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/16/23.
//

import Foundation

struct MapConnector: Codable {
    var id: String?
    var name: String
    var distance: Float?
    var map: Map?
    var points: [Point] = []

    public static func == (lhs: MapConnector, rhs: MapConnector) -> Bool
    {
        return lhs.id == rhs.id
    }
}
