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
    
    init() {}
    
    init(id: UUID? = nil, userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
}
