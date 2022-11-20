//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent
import Vapor

final class Point: Model, Content {
    static let schema = "points"
    
    @ID
    var id: UUID?
    
    @Field(key: "latitude")
    var latitude: Float
    
    @Field(key: "longitude")
    var longitude: Float
    
    @OptionalParent(key: "mapTrailId")
    var mapTrail: MapTrail?
    
    @OptionalParent(key: "mapConnectorId")
    var mapConnector: MapConnector?
    
    init() {}
    
    init(id: UUID? = nil, latitude: Float, longitude: Float, mapTrailID: MapTrail.IDValue?, mapConnectorID: MapConnector.IDValue?) {
        self.latitude = latitude
        self.longitude = longitude
        self.$mapTrail.id = mapTrailID
        self.$mapConnector.id = mapConnectorID
    }
}
