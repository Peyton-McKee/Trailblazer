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
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<TrailReport> {
        let data = try req.content.decode(CreateTrailReportData.self)
        
        let trailReport = TrailReport(type: data.type, latitude: data.latitude, longitude: data.longitude, dateMade: data.dateMade, trailMadeOn: data.trailMadeOn, userID: data.userID, mapID: data.mapID)
        
        return trailReport.save(on: req.db).map { trailReport }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[TrailReport]> {
        TrailReport.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<TrailReport> {
        
        TrailReport.find(req.parameters.get("trId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        TrailReport.find(req.parameters.get("trId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { trailReport in
                trailReport.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        TrailReport.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
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
