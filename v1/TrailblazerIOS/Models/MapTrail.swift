//
//  MapTrail.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/16/23.
//

import Foundation

struct MapTrail: Codable, Equatable {
    var id: String?
    var name: String
    var map: Map?
    var points: [Point] = []
    var difficulty: String

    public static func == (lhs: MapTrail, rhs: MapTrail) -> Bool
    {
        return lhs.id == rhs.id
    }
}
