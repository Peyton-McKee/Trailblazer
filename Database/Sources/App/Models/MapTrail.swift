//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent
import Vapor

final class MapTrail: Model, Content {
    static let schema = "mapTrails"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "difficulty")
    var difficulty: String
    
    @Field(key: "distance")
    var distance: Float
    
    @Field(key: "time")
    var time: Float
    
    @Parent(key: "mapID")
    var map: Map
    
    
    @Children(for: \.$mapTrail)
    var points: [Point]

    
    
    init() {}
    
    init(id: UUID? = nil, name: String, difficulty: String, mapID: Map.IDValue, distance: Float, time: Float) {
        self.name = name
        self.difficulty = difficulty
        self.distance = distance
        self.time = time
        self.$map.id = mapID
    }
}
