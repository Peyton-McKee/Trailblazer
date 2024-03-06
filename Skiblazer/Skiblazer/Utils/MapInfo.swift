//
//  MapInfo.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import UIKit

struct MapInfo {
    var easyTrails: GeoJSON
    var intermediateTrails: GeoJSON
    var advancedTrails: GeoJSON
    var expertsOnlyTrails: GeoJSON
    var lifts: GeoJSON
    var connectors: GeoJSON
    var terrainParks: GeoJSON
    var map: Map
}
