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
   
    @Parent(key: "mapID")
    var map: Map
    
    @Children(for: \.$mapConnector)
    var points: [Point]

    
    
    init() {}
    
    init(id: UUID? = nil, name: String, mapID: Map.IDValue) {
        self.name = name
        self.$map.id = mapID
    }
}

extension MapConnector {
    func transform(req: Request) -> EventLoopFuture<PublicMapConnector> {
        return self.$points.get(on: req.db).map({
            points in
            return PublicMapConnector(id: self.id!, name: self.name, points: points)
        })
    }
}
