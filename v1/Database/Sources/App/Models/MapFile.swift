//
//  File.swift
//  
//
//  Created by Peyton McKee on 12/27/22.
//


import Fluent
import Vapor

final class MapFile: Model, Content {
    static let schema = "map-files"
    
    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "file")
    var file: String
    
    @Field(key: "link")
    var link: String
    
    init() {}
    
    init(id: UUID? = nil, title: String, file: String, link: String) {
        self.title = title
        self.file = file
        self.link = link
    }
}
