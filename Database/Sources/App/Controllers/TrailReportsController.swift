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
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<TrailReport> {
        let trailReport = try req.content.decode(TrailReport.self)
        
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
    
}
