//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/20/22.
//

import Fluent

struct CreateMapConnectors: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("mapConnectors")
    
            .id()
    
            .field("name", .string, .required)
            
            .field("distance", .float, .required)
            .field("time", .float, .required)
        
            .field("mapID", .uuid, .required)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("mapConnectors").delete()
    }
}
