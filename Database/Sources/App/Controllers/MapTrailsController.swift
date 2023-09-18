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
    
    /**
     * Creates A Map Trail in the Database
     */
    func createHandler(_ req: Request) async throws -> MapTrail {
        let data = try req.content.decode(CreateMapTrailsData.self)
        
        let mapTrail = MapTrail(name: data.name, difficulty: data.difficulty, mapID: data.mapId)
        
        try await mapTrail.save(on: req.db)
        
        return mapTrail
    }
    
    /**
     * Gets all the map trails stored in the database
     */
    func getAllHandler(_ req: Request) async throws -> [MapTrail] {
        return try await MapTrail.query(on: req.db).all()
    }
    
    /**
     * Gets a map with the specified  id in the request
     */
    func getHandler(_ req: Request) async throws -> MapTrail {
        guard let mapTrail = try await MapTrail.find(req.parameters.get("mtId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return mapTrail
    }
    
    /**
     * Gets the points of the map trail
     */
    func getPointsHandler(_ req: Request) async throws -> [Point] {
        let mapTrail = try await getHandler(req)
        return try await mapTrail.$points.get(on: req.db)
    }
    
    /**
     * Deletes a map trail from the database with the speicifed id in the request
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let mapTrail = try await getHandler(req)
        
        try await mapTrail.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the map trails in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus
    {
        try await MapTrail.query(on: req.db).delete()
        
        return .noContent
    }
}

struct CreateMapTrailsData: Content{
    let name: String
    let difficulty: String
    let mapId: UUID
}

struct PublicMapTrail: Content {
    let id: UUID
    let name: String
    let difficulty: String
    let points: [Point]
}
