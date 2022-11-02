//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//

import Fluent

struct CreateUserLocations: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("userLocations")
    
            .id()
    
            .field("latitude", .double, .required)
            .field("longitude", .double, .required)
            .field("timeReported", .string, .required)
            .field("userID", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userLocations").delete()
    }
}
