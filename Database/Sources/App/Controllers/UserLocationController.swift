//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//

import Vapor


struct UserLocationController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let userLocationsRoute = routes.grouped("api", "user-locations")
        
        userLocationsRoute.post(use: createHandler)
        userLocationsRoute.get(use: getAllHandler)
        userLocationsRoute.get(":ulId", use: getHandler)
        userLocationsRoute.delete(":ulId", use: deleteHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<UserLocation> {
        let data = try req.content.decode(CreateUserLocationData.self)
        
        let userLocation = UserLocation(latitude: data.latitude, longitude: data.longitude, timeReported: data.timeReported, userID: data.userID)
        
        return userLocation.save(on: req.db).map { userLocation }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[UserLocation]> {
        UserLocation.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<UserLocation> {
        
        UserLocation.find(req.parameters.get("ulId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        UserLocation.find(req.parameters.get("ulId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userLocation in
                userLocation.delete(on: req.db).transform(to: .noContent)
            }
    }
}

struct CreateUserLocationData: Content{
    let latitude: Double
    let longitude: Double
    let timeReported: String
    let userID: UUID
}
