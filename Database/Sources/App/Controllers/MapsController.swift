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
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<Map> {
        let data = try req.content.decode(CreateMapData.self)
        
        let map = Map(name: data.name, initialLocationLatitude: data.initialLocationLatitude, initialLocationLongitude: data.initialLocationLongitude, mountainReportUrl: data.mountainReportUrl, liftStatusElementId: data.liftStatusElementId, trailStatusElementId: data.trailStatusElementId)
        
        return map.save(on: req.db).map { map }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Map]> {
        Map.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) async throws -> PublicMap {
        guard let map = try await Map.find(req.parameters.get("mapId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
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
    
    func getTrailReportsHandler(_ req: Request) async throws -> [TrailReport] {
        guard let map = try await Map.find(req.parameters.get("mapId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await map.$trailReports.get(on: req.db)
    }
    
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let map = try await Map.find(req.parameters.get("mapId"), on: req.db) else {
            throw Abort(.notFound)
        }
        let mapConnectors = try await map.$mapConnector.get(on: req.db)
        
        for mapConnector in mapConnectors {
            let points = try await mapConnector.$points.get(on: req.db)
            try await points.delete(on: req.db)
        }
        
        try await mapConnectors.delete(on: req.db)
        
        let mapTrails = try await map.$mapTrail.get(on: req.db)
        
        for mapTrail in mapTrails {
            let points = try await mapTrail.$points.get(on: req.db)
            try await points.delete(on: req.db)
        }
        
        try await mapTrails.delete(on: req.db)
        
        try await map.delete(on: req.db)
        
        return .noContent
    }
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let maps = try await Map.query(on: req.db).all()
        
        for map in maps {
            let mapConnectors = try await map.$mapConnector.get(on: req.db)
            
            for mapConnector in mapConnectors {
                let points = try await mapConnector.$points.get(on: req.db)
                try await points.delete(on: req.db)
            }
            
            try await mapConnectors.delete(on: req.db)
            
            let mapTrails = try await map.$mapTrail.get(on: req.db)
            
            for mapTrail in mapTrails {
                let points = try await mapTrail.$points.get(on: req.db)
                try await points.delete(on: req.db)
            }
            
            try await mapTrails.delete(on: req.db)
            
            try await map.delete(on: req.db)
        }
        
        return .noContent
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
