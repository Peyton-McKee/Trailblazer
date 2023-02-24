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
        
            .field("initialLocationLongitude", .float, .required)
        
            .field("initialLocationLatitude", .float, .required)
        
            .field("mountainReportUrl", .string)
        
            .field("trailStatusElementId", .string)
        
            .field("liftStatusElementId", .string)
        
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("maps").delete()
    }
}
