//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//
import Fluent
import Vapor

final class UserRoute: Model, Content {
    static let schema = "userRoutes"
    
    @ID
    var id: UUID?
    
    @Field(key: "destinationTrailName")
    var destinationTrailName: String
    
    @Field(key: "originTrailName")
    var originTrailName: String
    
    @Field(key: "dateMade")
    var dateMade: String
    
    @Field(key: "timeTook")
    var timeTook: Int
    
    @Parent(key: "userID")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, destinationTrailName: String, originTrailName: String, dateMade: String, timeTook: Int, userID: User.IDValue) {
        self.destinationTrailName = destinationTrailName
        self.originTrailName = originTrailName
        self.dateMade = dateMade
        self.timeTook = timeTook
        self.$user.id = userID
    }
}
