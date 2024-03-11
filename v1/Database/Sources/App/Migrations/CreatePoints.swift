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
        
            .field("order", .int, .required)
        
            .field("time", .array(of: .double), .required)
        
            .field("mapTrailID", .uuid, .references("mapTrails", "id"))
        
            .field("mapConnectorID", .uuid, .references("mapConnectors", "id"))
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("points").delete()
    }
}
