//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/19/22.
//

import Fluent

struct CreateTrailReports: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("trailReports")
    
            .id()
    
            .field("type", .string, .required)
            .field("latitude", .double, .required)
            .field("longitude", .double, .required)
            .field("dateMade", .string, .required)
            .field("trailMadeOn", .string, .required)
            .field("userID", .uuid, .required)
            .field("mapID", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("trailReports").delete()
    }
}
