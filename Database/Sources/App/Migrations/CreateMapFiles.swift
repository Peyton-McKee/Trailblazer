//
//  File.swift
//  
//
//  Created by Peyton McKee on 12/27/22.
//

import Fluent

struct CreateMapFiles: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("map-files")
    
            .id()
    
            .field("title", .string, .required)
            .field("file", .string, .required)
            .field("link", .string, .required)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("map-files").delete()
    }
}
