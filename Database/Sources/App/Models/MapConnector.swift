//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/20/22.
//

import Fluent
import Vapor

final class MapConnector: Model, Content {
    static let schema = "mapConnectors"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "distance")
    var distance: Float
    
    @Field(key: "time")
    var time: Float
    @Parent(key: "mapID")
    var map: Map
    
    @Children(for: \.$mapConnector)
    var points: [Point]

    
    
    init() {}
    
    init(id: UUID? = nil, name: String, mapID: Map.IDValue, distance: Float, time: Float) {
        self.name = name
        self.distance = distance
        self.time = time
        self.$map.id = mapID
    }
}
