//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//

import Fluent
import Vapor

final class UserLocation: Model, Content {
    static let schema = "userLocations"
    
    @ID
    var id: UUID?
    
    @Field(key: "latitude")
    var latitude: String
    
    @Field(key: "longitude")
    var longitude: String
    
    @Field(key: "timeReported")
    var timeReported: String
    
    @Parent(key: "userID")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, latitude: String, longitude: String, timeReported: String, userID: User.IDValue) {
        self.latitude = latitude
        self.longitude = longitude
        self.timeReported = timeReported
        self.$user.id = userID
    }
}
