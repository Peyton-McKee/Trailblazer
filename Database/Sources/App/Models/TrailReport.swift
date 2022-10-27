//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/19/22.
//

import Fluent
import Vapor

final class TrailReport: Model, Content {
    static let schema = "trailReports"
    
    @ID
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "latitude")
    var latitude: Double
    
    @Field(key: "longitude")
    var longitude: Double
    
    @Field(key: "dateMade")
    var dateMade: String
    
    @Field(key: "trailMadeOn")
    var trailMadeOn: String
    
    @Parent(key: "userID")
    var user: User
    
    
    init() {}
    
    init(id: UUID? = nil, type: String, latitude: Double, longitude: Double, dateMade: String, trailMadeOn: String, userID: User.IDValue) {
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.dateMade = dateMade
        self.trailMadeOn = trailMadeOn
        self.$user.id = userID
    }
}
