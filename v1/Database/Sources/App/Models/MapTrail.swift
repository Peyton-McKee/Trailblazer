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
extension MapTrail {
    func transform(req: Request) async throws -> PublicMapTrail {
        let points = try await self.$points.get(on: req.db)
        return PublicMapTrail(id: self.id!, name: self.name, difficulty: self.difficulty, points: points.sorted(by: {
                $0.order < $1.order }))
    }
}
