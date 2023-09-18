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
        pointsRoute.delete( use: deleteAllHandler)
        pointsRoute.put(":pointId", use: updateHandler)
        
    }
    
    /**
     * Creates a point in the database
     */
    func createHandler(_ req: Request) async throws -> Point {
        let data = try req.content.decode(CreatePointData.self)
        
        let point = Point(latitude: data.latitude, longitude: data.longitude, mapTrailID: data.mapTrailId, mapConnectorID: data.mapConnectorId, time: data.time, order: data.order)
        
        try await point.save(on: req.db)
        
        return point
    }
    
    /**
     * Gets all the points from the database
     */
    func getAllHandler(_ req: Request) async throws -> [Point] {
        return try await Point.query(on: req.db).all()
    }
    
    /**
     * Gets a single point from the database with the given point id
     */
    func getHandler(_ req: Request) async throws-> Point {
        guard let point = try await Point.find(req.parameters.get("pointId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return point
    }
    
    /**
     * Deletes a point from the database
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let point = try await getHandler(req)
        
        try await point.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Updates the point in the database with a new time array
     */
    func updateHandler(_ req: Request) async throws -> Point {
        let point = try await getHandler(req)
        
        let updatedPointData = try req.content.decode(updatePointTimeData.self)
        
        point.time = updatedPointData.time
        do {
            try await point.update(on: req.db)
        } catch {
            print("ERROR: ", error)
            throw Abort(HTTPResponseStatus(statusCode: 400, reasonPhrase: error.localizedDescription))
        }
        
        return point
    }
    
    /**
     * Deletes all the points in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allPoints = try await getAllHandler(req)
        
        try await allPoints.delete(on: req.db)
        
        return .noContent
    }
}

struct CreatePointData: Content{
    let latitude: Float
    let longitude: Float
    let mapTrailId: UUID?
    let time: [Double]
    let mapConnectorId: UUID?
    let order: Int
}

struct updatePointTimeData: Content {
    let time: [Double]
}
