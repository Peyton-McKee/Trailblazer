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
        userLocationsRoute.delete( use: deleteAllHandler)
        
    }
    
    /**
     * Creates a user location in the database
     */
    func createHandler(_ req: Request) async throws -> UserLocation {
        let data = try req.content.decode(CreateUserLocationData.self)
        
        let userLocation = UserLocation(latitude: data.latitude, longitude: data.longitude, timeReported: data.timeReported, userID: data.userID)
        
        try await userLocation.save(on: req.db)
        
        return userLocation
    }
    
    /**
     * Gets all the user locations from the database
     */
    func getAllHandler(_ req: Request) async throws -> [UserLocation] {
        return try await UserLocation.query(on: req.db).all()
    }
    
    /**
     * Gets the user location with the specified id
     */
    func getHandler(_ req: Request) async throws -> UserLocation {
        guard let userLocation = try await UserLocation.find(req.parameters.get("ulId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return userLocation
    }
    
    /**
     * Deletes  the user location with the specified Id
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let userLocation = try await getHandler(req)
        
        try await userLocation.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the user locations from the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allUserLocations = try await getAllHandler(req)
        
        try await allUserLocations.delete(on: req.db)
        
        return .noContent
    }
}

struct CreateUserLocationData: Content{
    let latitude: Double
    let longitude: Double
    let timeReported: String
    let userID: UUID
}
