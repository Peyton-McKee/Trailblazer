//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent
import Vapor

final class Map: Model, Content {
    static let schema = "maps"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$map)
    var mapTrail: [MapTrail]
    
    @Children(for: \.$map)
    var mapConnector: [MapConnector]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.name = name
    }
}
