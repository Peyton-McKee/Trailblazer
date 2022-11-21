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
    
    @Parent(key: "mapID")
    var map: Map
    
    
    @Children(for: \.$mapTrail)
    var points: [Point]

    
    
    init() {}
    
    init(id: UUID? = nil, name: String, difficulty: String, mapID: Map.IDValue) {
        self.name = name
        self.difficulty = difficulty
        self.$map.id = mapID
    }
}
