//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent

struct CreateMapTrails: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("mapTrails")
    
            .id()
    
            .field("name", .string, .required)
            
            .field("mapID", .uuid, .required)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("mapTrails").delete()
    }
}
