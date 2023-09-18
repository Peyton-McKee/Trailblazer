//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/19/22.
//

import Vapor


struct TrailReportsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let trailReportsRoute = routes.grouped("api", "trail-reports")
        
        trailReportsRoute.post(use: createHandler)
        trailReportsRoute.get(use: getAllHandler)
        trailReportsRoute.get(":trId", use: getHandler)
        trailReportsRoute.delete(":trId", use: deleteHandler)
        trailReportsRoute.delete( use: deleteAllHandler)
        
    }
    
    /**
     * Creates a trail report in the database
     */
    func createHandler(_ req: Request) async throws -> TrailReport {
        let data = try req.content.decode(CreateTrailReportData.self)
        
        let trailReport = TrailReport(type: data.type, latitude: data.latitude, longitude: data.longitude, dateMade: data.dateMade, trailMadeOn: data.trailMadeOn, userID: data.userID, mapID: data.mapID)
        
        try await trailReport.save(on: req.db)
        
        return trailReport
    }
    
    /**
     * Gets all the trail reports in the databse
     */
    func getAllHandler(_ req: Request) async throws -> [TrailReport] {
        return try await TrailReport.query(on: req.db).all()
    }
    
    /**
     * Gets the trail report with the specified id from the database
     */
    func getHandler(_ req: Request) async throws -> TrailReport {
        guard let trailReport = try await TrailReport.find(req.parameters.get("trId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return trailReport
    }
    
    /**
     * Deletes the trail report with the specified id from the database
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let trailReport = try await getHandler(req)
        
        try await trailReport.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the trail reports stored in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allTrailReports = try await getAllHandler(req)
        
        try await allTrailReports.delete(on: req.db)
        
        return .noContent
    }
}

struct CreateTrailReportData: Content{
    let type: String
    let latitude: Double
    let longitude: Double
    let dateMade: String
    let trailMadeOn: String
    let userID: UUID
    let mapID: UUID
}
