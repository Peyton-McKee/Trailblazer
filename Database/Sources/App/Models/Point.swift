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
    
    @Field(key: "order")
    var order: Int
    
    @Field(key: "time")
    var time: [Float]
    
    @OptionalParent(key: "mapTrailID")
    var mapTrail: MapTrail?
    
    @OptionalParent(key: "mapConnectorID")
    var mapConnector: MapConnector?
    
    init() {}
    
    init(id: UUID? = nil, latitude: Float, longitude: Float, mapTrailID: MapTrail.IDValue?, mapConnectorID: MapConnector.IDValue?, time: [Float], order: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.$mapTrail.id = mapTrailID
        self.$mapConnector.id = mapConnectorID
        self.time = time
        self.order = order
    }
}
