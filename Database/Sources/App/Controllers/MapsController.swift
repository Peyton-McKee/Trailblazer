//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Vapor


struct MapsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let mapsRoute = routes.grouped("api", "maps")
        
        mapsRoute.post(use: createHandler)
        mapsRoute.get(use: getAllHandler)
        mapsRoute.get(":mapId", use: getHandler)
        mapsRoute.get(":mapId", "map-trails", use: getMapTrailsHandler)
        mapsRoute.get(":mapId", "map-connectors", use: getMapConnectorsHandler)
        mapsRoute.delete(":mapId", use: deleteHandler)
        mapsRoute.delete(use: deleteAllHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<Map> {
        let data = try req.content.decode(CreateMapData.self)
        
        let map = Map(name: data.name)
        
        return map.save(on: req.db).map { map }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Map]> {
        Map.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<Map> {
        Map.find(req.parameters.get("mapId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
    }
    func getMapTrailsHandler(_ req: Request)
      -> EventLoopFuture<[MapTrail]> {
      // 2
      Map.find(req.parameters.get("mapId"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { map in
          // 3
          map.$mapTrail.get(on: req.db)
        }
    }
    func getMapConnectorsHandler(_ req: Request) -> EventLoopFuture<[MapConnector]> {
        Map.find(req.parameters.get("mapId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ map in
                map.$mapConnector.get(on: req.db)
            }
    }
    
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        Map.find(req.parameters.get("mapId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { map in
                map.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        Map.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
    }
}

struct CreateMapData: Content{
    let name: String
}
