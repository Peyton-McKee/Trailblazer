//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//


import Vapor

struct MapTrailsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let mapTrailsRoute = routes.grouped("api", "map-trails")
        
        mapTrailsRoute.post(use: createHandler)
        mapTrailsRoute.get(use: getAllHandler)
        mapTrailsRoute.get(":mtId", use: getHandler)
        mapTrailsRoute.delete(":mtId", use: deleteHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<MapTrail> {
        let data = try req.content.decode(CreateMapTrailsData.self)
        
        let mapTrail = MapTrail(name: data.name, mapID: data.mapId)
        
        return mapTrail.save(on: req.db).map { mapTrail }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[MapTrail]> {
        MapTrail.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<MapTrail> {
        
        MapTrail.find(req.parameters.get("mtId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        MapTrail.find(req.parameters.get("mtId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { mapTrail in
                mapTrail.delete(on: req.db).transform(to: .noContent)
            }
    }
}

struct CreateMapTrailsData: Content{
    let name: String
    let mapId: UUID
}
