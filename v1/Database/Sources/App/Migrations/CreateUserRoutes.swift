//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//

import Fluent

struct CreateUserRoutes: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("userRoutes")
    
            .id()
    
            .field("destinationTrailName", .string, .required)
            .field("originTrailName", .string, .required)
            .field("dateMade", .string, .required)
            .field("timeTook", .int, .required)
            .field("userID", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userRoutes").delete()
    }
}
