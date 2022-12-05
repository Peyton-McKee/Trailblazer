//
//  File.swift
//
//
//  Created by Peyton McKee on 11/16/22.
//


import Vapor

struct MapConnectorsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let mapConnectorsRoute = routes.grouped("api", "map-connectors")
        
        mapConnectorsRoute.post(use: createHandler)
        mapConnectorsRoute.get(use: getAllHandler)
        mapConnectorsRoute.get(":mcId", use: getHandler)
        mapConnectorsRoute.get(":mcId", "points", use: getPointsHandler)
        mapConnectorsRoute.delete(":mcId", use: deleteHandler)
        mapConnectorsRoute.delete( use: deleteAllHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<MapConnector> {
        let data = try req.content.decode(CreateMapConnectorData.self)
        
        let mapConnector = MapConnector(name: data.name, mapID: data.mapId)
        
        return mapConnector.save(on: req.db).map { mapConnector }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[MapConnector]> {
        MapConnector.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<MapConnector> {
        
        MapConnector.find(req.parameters.get("mcId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func getPointsHandler(_ req: Request)
      -> EventLoopFuture<[Point]> {
      // 2
      MapConnector.find(req.parameters.get("mcId"), on: req.db)
              .unwrap(or: Abort(.notFound))
              .flatMap({
                  mapConnector in
                  mapConnector.$points.get(on: req.db)
                  
              })
    }
    
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        MapConnector.find(req.parameters.get("mcId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { mapConnector in
                mapConnector.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        MapConnector.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
    }
}

struct CreateMapConnectorData: Content{
    let name: String
    let mapId: UUID
}
