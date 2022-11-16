//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Fluent

struct CreateMaps: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("maps")
    
            .id()
    
            .field("name", .string, .required)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("maps").delete()
    }
}
