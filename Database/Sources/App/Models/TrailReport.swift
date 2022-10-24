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
    
    @Field(key: "location")
    var location: String
    
    @Parent(key: "userID")
    var user: User
    
    
    init() {}
    
    init(id: UUID? = nil, type: String, location: String, userID: User.IDValue) {
        self.type = type
        self.location = location
        self.$user.id = userID
    }
}
