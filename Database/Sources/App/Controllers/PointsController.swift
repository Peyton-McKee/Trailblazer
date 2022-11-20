//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Vapor

struct PointsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let pointsRoute = routes.grouped("api", "points")
        
        pointsRoute.post(use: createHandler)
        pointsRoute.get(use: getAllHandler)
        pointsRoute.get(":pointId", use: getHandler)
        pointsRoute.delete(":pointId", use: deleteHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<Point> {
        let data = try req.content.decode(CreatePointData.self)
        
        let point = Point(latitude: data.latitude, longitude: data.longitude, mapTrailID: data.mapTrailId, mapConnectorID: data.mapConnectorId)
        
        return point.save(on: req.db).map { point }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Point]> {
        Point.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<Point> {
        
        Point.find(req.parameters.get("pointId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        Point.find(req.parameters.get("pointId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { point in
                point.delete(on: req.db).transform(to: .noContent)
            }
    }
}

struct CreatePointData: Content{
    let latitude: Float
    let longitude: Float
    let mapTrailId: UUID?
    let mapConnectorId: UUID?
}
