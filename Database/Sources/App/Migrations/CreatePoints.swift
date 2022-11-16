//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent

struct CreatePoints: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("points")
    
            .id()
    
            .field("latitude", .float, .required)
            
            .field("longitude", .float, .required)
            
            .field("mapTrailId", .uuid, .required)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("points").delete()
    }
}
