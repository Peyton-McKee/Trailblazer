//
//  File.swift
//  
//
//  Created by Peyton McKee on 11/16/22.
//

import Vapor
import Fluent

struct MapsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let mapsRoute = routes.grouped("api", "maps")
        
        mapsRoute.post(use: createHandler)
        mapsRoute.get(use: getAllHandler)
        mapsRoute.get(":mapId", use: getHandler)
        mapsRoute.get(":mapId", "map-trails", use: getMapTrailsHandler)
        mapsRoute.get(":mapId", "map-connectors", use: getMapConnectorsHandler)
        mapsRoute.get(":mapId", "trail-reports", use: getTrailReportsHandler)
        mapsRoute.delete(":mapId", use: deleteHandler)
        mapsRoute.delete(use: deleteAllHandler)
    }
    
    /**
     * Creates a map  in the database
     */
    func createHandler(_ req: Request) async throws -> Map {
        let data = try req.content.decode(CreateMapData.self)
        
        let map = Map(name: data.name, initialLocationLatitude: data.initialLocationLatitude, initialLocationLongitude: data.initialLocationLongitude, mountainReportUrl: data.mountainReportUrl, liftStatusElementId: data.liftStatusElementId, trailStatusElementId: data.trailStatusElementId)
        
        try await map.save(on: req.db)
        return map
    }
    
    /**
     * Gets all the maps in the database
     */
    func getAllHandler(_ req: Request) async throws -> [Map] {
        return try await Map.query(on: req.db).all()
    }
    
    /**
     * Gets the sole map object from the database based on the paramaters of the request
     */
    func getMap(_ req: Request) async throws -> Map {
        guard let map = try await Map.find(req.parameters.get("mapId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return map
    }
    
    /**
     * Gets a single map with its connectors and trails based on the given id passed in the req paramters
     */
    func getHandler(_ req: Request) async throws -> PublicMap {
        let map = try await getMap(req)
        
        let mapConnectors = try await map.$mapConnector.get(on: req.db)
        
        var publicMapConnectors : [PublicMapConnector] = []
        
        for mapConnector in mapConnectors {
            try await publicMapConnectors.append(mapConnector.transform(req: req))
        }
        
        let mapTrails = try await map.$mapTrail.get(on: req.db)
        
        var publicMapTrails : [PublicMapTrail] = []
        
        for mapTrail in mapTrails {
            try await publicMapTrails.append(mapTrail.transform(req: req))
        }
        
        return PublicMap(id: map.id!, name: map.name, initialLocationLatitude: map.initialLocationLatitude, initialLocationLongitude: map.initialLocationLongitude, mountainReportUrl: map.mountainReportUrl, trailStatusElementId: map.trailStatusElementId, liftStatusElementId: map.liftStatusElementId, mapTrail: publicMapTrails, mapConnector: publicMapConnectors)
    }
    
   
    
    /**
     * Gets the map trails from the map requested in the req params
     */
    func getMapTrailsHandler(_ req: Request) async throws -> [MapTrail] {
        let map = try await getMap(req)
        
        return try await map.$mapTrail.get(on: req.db)
    }
    
    /**
     * Gets the map connectors from the map requested in the req params
     */
    func getMapConnectorsHandler(_ req: Request) async throws -> [MapConnector] {
        let map = try await getMap(req)
        
        return try await map.$mapConnector.get(on: req.db)
    }
    
    /**
     * Gets all the trail reports from the map requested in the req params
     */
    func getTrailReportsHandler(_ req: Request) async throws -> [TrailReport] {
        let map = try await getMap(req)
        
        return try await map.$trailReports.get(on: req.db)
    }
    
    /**
     * Deletes a map in the database along with all its associated points, connectors and trails
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let map = try await getMap(req)
        
        try await deleteMap(map: map, db: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the maps and all assocaited objects in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let maps = try await getAllHandler(req)
        
        for map in maps {
            try await deleteMap(map: map, db: req.db)
        }
        
        return .noContent
    }
    
    /**
     * Deletes the given map along with all associated models in the database
     */
    func deleteMap(map: Map, db: Database) async throws -> Void {
        let mapConnectors = try await map.$mapConnector.get(on: db)
        
        for mapConnector in mapConnectors {
            let points = try await mapConnector.$points.get(on: db)
            try await points.delete(on: db)
        }
        
        try await mapConnectors.delete(on: db)
        
        let mapTrails = try await map.$mapTrail.get(on: db)
        
        for mapTrail in mapTrails {
            let points = try await mapTrail.$points.get(on: db)
            try await points.delete(on: db)
        }
        
        try await mapTrails.delete(on: db)
        
        try await map.delete(on: db)
    }
}

struct CreateMapData: Content{
    let name: String
    let initialLocationLatitude: Float
    let initialLocationLongitude: Float
    let mountainReportUrl: String?
    let trailStatusElementId: String?
    let liftStatusElementId: String?
}

struct PublicMap: Content {
    let id: UUID
    let name: String
    let initialLocationLatitude: Float
    let initialLocationLongitude: Float
    let mountainReportUrl: String?
    let trailStatusElementId: String?
    let liftStatusElementId: String?
    let mapTrail: [PublicMapTrail]
    let mapConnector: [PublicMapConnector]
}
