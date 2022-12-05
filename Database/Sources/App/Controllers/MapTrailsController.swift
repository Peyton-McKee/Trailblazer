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
        mapTrailsRoute.get(":mtId", "points", use: getPointsHandler)
        mapTrailsRoute.delete(":mtId", use: deleteHandler)
        mapTrailsRoute.delete(use: deleteAllHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<MapTrail> {
        let data = try req.content.decode(CreateMapTrailsData.self)
        
        let mapTrail = MapTrail(name: data.name, difficulty: data.difficulty, mapID: data.mapId)
        
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
    func getPointsHandler(_ req: Request)
      -> EventLoopFuture<[Point]> {
      // 2
      MapTrail.find(req.parameters.get("mtId"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { mapTrail in
          // 3
          mapTrail.$points.get(on: req.db)
        }
    }
    
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        MapTrail.find(req.parameters.get("mtId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { mapTrail in
                mapTrail.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) -> EventLoopFuture<HTTPStatus>
    {
        MapTrail.query(on: req.db).delete().transform(to: .noContent)
    }
}

struct CreateMapTrailsData: Content{
    let name: String
    let difficulty: String
   
    let mapId: UUID
}
