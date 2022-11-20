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
    
    @Parent(key: "mapId")
    var map: Map
    
    @Children(for: \.$mapConnector)
    var points: [Point]

    
    
    init() {}
    
    init(id: UUID? = nil, name: String, mapID: Map.IDValue) {
        self.name = name
        self.$map.id = mapID
    }
}
