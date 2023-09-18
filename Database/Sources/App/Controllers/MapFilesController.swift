//
//  File.swift
//  
//
//  Created by Peyton McKee on 12/27/22.
//


import Vapor


struct MapFilesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let mapFilesRoute = routes.grouped("api", "map-files")
        
        mapFilesRoute.post(use: createHandler)
        mapFilesRoute.get(use: getAllHandler)
        mapFilesRoute.get(":mapFileId", use: getHandler)
        mapFilesRoute.delete(":mapFileId", use: deleteHandler)
        mapFilesRoute.delete(use: deleteAllHandler)
    }
    
    /**
     * Creates a map file in the database
     */
    func createHandler(_ req: Request) async throws -> MapFile {
        let data = try req.content.decode(CreateMapFileData.self)
        
        let mapFile = MapFile(title: data.title, file: data.file, link: data.link)
        
        try await mapFile.save(on: req.db)
        
        return mapFile
    }
    
    /**
     * Gets all the map files in the database
     */
    func getAllHandler(_ req: Request) async throws -> [MapFile] {
        return try await MapFile.query(on: req.db).all()
    }
    
    /**
     * Gets a single Map File from the database that correlates with the given mapFileId
     */
    func getHandler(_ req: Request) async throws -> MapFile {
        guard let mapFile = try await MapFile.find(req.parameters.get("mapFileId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return mapFile
    }
    
    /**
     * Deletes a map file from the database with the given mapFileId
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let mapFile = try await getHandler(req)
        
        try await mapFile.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the map files from the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let mapFiles = try await getAllHandler(req)
        
        try await mapFiles.delete(on: req.db)
        
        return .noContent
    }
}

struct CreateMapFileData: Content{
    let title: String
    let file: String
    let link: String
}
