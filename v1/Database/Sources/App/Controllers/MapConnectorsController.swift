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
    
    /**
     * Creates a Map Connector in the database
     */
    func createHandler(_ req: Request) async throws -> MapConnector {
        let data = try req.content.decode(CreateMapConnectorData.self)
        
        let mapConnector = MapConnector(name: data.name, mapID: data.mapId)
        
        try await mapConnector.save(on: req.db)
        
        return mapConnector
    }
    
    /**
     * Gets all the maps in the database
     */
    func getAllHandler(_ req: Request) async throws -> [MapConnector] {
        return try await MapConnector.query(on: req.db).all()
    }
    
    /**
     * Gets a single map from the database with the given id
     */
    func getHandler(_ req: Request) async throws -> MapConnector {
        guard let mapConnector = try await MapConnector.find(req.parameters.get("mcId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return mapConnector
    }
    
    /**
     * Gets all the points for the given map connector
     */
    func getPointsHandler(_ req: Request) async throws -> [Point] {
        let mapConnector = try await getHandler(req)
        return try await mapConnector.$points.get(on: req.db)
    }
    
    /**
     * Deletes the map connector that correlates to the given map connector id
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let mapConnector = try await getHandler(req)
        
        try await mapConnector.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the map connectors in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allMapConnectors = try await getAllHandler(req)
        
        try await allMapConnectors.delete(on: req.db)
        
        return .noContent
    }
}

struct CreateMapConnectorData: Content{
    let name: String
    let mapId: UUID
}

struct PublicMapConnector: Content {
    let id: UUID
    let name: String
    let points: [Point]
}
