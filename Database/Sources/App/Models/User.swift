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
    
    @Field(key: "username")
    var username: String
    
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
    
    init(id: UUID? = nil, username: String, password: String, alertSettings: [String], routingPreference: String) {
        self.username = username
        self.password = password
        self.alertSettings = alertSettings
        self.routingPreference = routingPreference
    }
}
extension User {
    static func create(from userSignup: UserSignUp) throws -> User {
        User(username: userSignup.username, password: try Bcrypt.hash(userSignup.password), alertSettings: [], routingPreference: "Easiest")
    }
}
extension User: ModelAuthenticatable {
  static let usernameKey = \User.$username
  static let passwordHashKey = \User.$password
  
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.password)
  }
}
