//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/4/22.
//

import Fluent


struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("users")
        
            .id()
        
            .field("userName", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("alertSettings", .array(of: .string), .required)
            .field("routingPreference", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
