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
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<MapFile> {
        let data = try req.content.decode(CreateMapFileData.self)
        
        let mapFile = MapFile(title: data.title, file: data.file)
        
        return mapFile.save(on: req.db).map { mapFile }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[MapFile]> {
        MapFile.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<MapFile> {
        MapFile.find(req.parameters.get("mapFileId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        MapFile.find(req.parameters.get("mapFileId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { mapFile in
                mapFile.delete(on: req.db).transform(to: HTTPStatus.noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        MapFile.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
    }
}

struct CreateMapFileData: Content{
    let title: String
    let file: String
}
