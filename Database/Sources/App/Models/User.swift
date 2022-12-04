//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/4/22.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "userName")
    var userName: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: String
    
    @Field(key: "alertSettings")
    var alertSettings: [String]
    
    @Field(key: "routingPreference")
    var routingPreference: String
    
    @Children(for: \.$user)
    var trailReports: [TrailReport]
    
    @Children(for: \.$user)
    var userLocations: [UserLocation]
    
    @Children(for: \.$user)
    var userRoutes: [UserRoute]
    
    init() {}
    
    init(id: UUID? = nil, userName: String, password: String, alertSettings: [String], routingPreference: String) {
        self.userName = userName
        self.password = password
        self.alertSettings = alertSettings
        self.routingPreference = routingPreference
    }
}
