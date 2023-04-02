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
    func transform(req: Request) async throws -> PublicMapConnector {
        let points = try await self.$points.get(on: req.db)
        return PublicMapConnector(id: self.id!, name: self.name, points: points.sorted(by: { $0.order < $1.order }))
    }
}
