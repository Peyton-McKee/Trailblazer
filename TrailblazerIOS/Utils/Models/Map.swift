//
//  Map.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

struct Map : Codable, Equatable
{
    var id: String?
    var name: String?
    var initialLocationLatitude: Float?
    var initialLocationLongitude: Float?
    var mapTrail: [MapTrail]?
    var mapConnector: [MapConnector]?
    var mountainReportUrl: String?
    var trailStatusElementId: String?
    var liftStatusElementId: String?
    public static func == (lhs: Map, rhs: Map) -> Bool
    {
        return lhs.id == rhs.id
    }
}

struct MapTrail: Codable, Equatable {
    var id: String?
    var name: String?
    var map: Map?
    var points: [Point]?
    var difficulty: String?
    
    public static func == (lhs: MapTrail, rhs: MapTrail) -> Bool
    {
        return lhs.id == rhs.id
    }
}

struct MapConnector: Codable {
    var id: String?
    var name: String?
    var distance: Float?
    var map: Map?
    var points: [Point]?
}
