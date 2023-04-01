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
    
    @Field(key: "initialLocationLatitude")
    var initialLocationLatitude: Float
    
    @Field(key: "initialLocationLongitude")
    var initialLocationLongitude: Float
    
    @Field(key: "mountainReportUrl")
    var mountainReportUrl: String?
    
    @Field(key: "liftStatusElementId")
    var liftStatusElementId: String?
    
    @Field(key: "trailStatusElementId")
    var trailStatusElementId: String?
    
    
    @Children(for: \.$map)
    var mapTrail: [MapTrail]
    
    @Children(for: \.$map)
    var mapConnector: [MapConnector]
    
    @Children(for: \.$map)
    var trailReports: [TrailReport]
    
    init() {}
    
    init(id: UUID? = nil, name: String, initialLocationLatitude: Float, initialLocationLongitude: Float, mountainReportUrl: String?, liftStatusElementId: String?, trailStatusElementId: String?){
        self.name = name
        self.initialLocationLatitude = initialLocationLatitude
        self.initialLocationLongitude = initialLocationLongitude
        self.mountainReportUrl = mountainReportUrl
        self.liftStatusElementId = liftStatusElementId
        self.trailStatusElementId = trailStatusElementId
    }
}
