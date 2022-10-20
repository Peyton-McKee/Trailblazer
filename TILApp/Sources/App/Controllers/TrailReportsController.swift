//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/19/22.
//

import Vapor

// 1
struct TrailReportsController: RouteCollection {
  // 2
  func boot(routes: RoutesBuilder) throws {
    // 3
    let trailReportsRoute = routes.grouped("api", "trail-reports")
    // 4
    trailReportsRoute.post(use: createHandler)
    trailReportsRoute.get(use: getAllHandler)
    trailReportsRoute.get(":trId", use: getHandler)
    trailReportsRoute.delete(":trId", use: deleteHandler)
  }

  // 5
  func createHandler(_ req: Request)
    throws -> EventLoopFuture<TrailReport> {
    // 6
    let trailReport = try req.content.decode(TrailReport.self)
    // 7
    return trailReport.save(on: req.db).map { trailReport }
  }
  func getAllHandler(_ req: Request) -> EventLoopFuture<[TrailReport]> {
        TrailReport.query(on: req.db).all()
  }
  func getHandler(_ req: Request)
      -> EventLoopFuture<TrailReport> {
      // 4
      TrailReport.find(req.parameters.get("trId"), on: req.db)
          .unwrap(or: Abort(.notFound))
  }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("trId"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { trailReport in
            trailReport.delete(on: req.db).transform(to: .noContent)
          }
    }
    
}
