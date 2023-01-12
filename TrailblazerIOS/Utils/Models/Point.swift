//
//  Point.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/2/23.
//

import Foundation

struct Point: Codable {
    var id: String?
    var mapTrailId: MapTrail?
    var mapConnectorId: MapConnector?
    var latitude: Float
    var longitude: Float
    var distance: Float?
    var time: [Float]?
}

struct PointTimeUpdateData: Codable{
    var id: String
    var time: [Float]
    
}
