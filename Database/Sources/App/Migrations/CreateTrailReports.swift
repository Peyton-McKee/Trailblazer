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
            .field("location", .string, .required)
    
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("trailReports").delete()
    }
}
