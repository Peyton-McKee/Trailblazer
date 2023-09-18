//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/27/22.
//

import Vapor


struct UserRoutesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let userRoutesRoute = routes.grouped("api", "user-routes")
        
        userRoutesRoute.post(use: createHandler)
        userRoutesRoute.get(use: getAllHandler)
        userRoutesRoute.get(":urId", use: getHandler)
        userRoutesRoute.delete(":urId", use: deleteHandler)
        userRoutesRoute.delete(use: deleteAllHandler)
        
    }
    
    /**
     * Creates a user route in the database
     */
    func createHandler(_ req: Request) throws -> EventLoopFuture<UserRoute> {
        let data = try req.content.decode(CreateUserRoutesData.self)
        
        let userLocation = UserRoute(destinationTrailName: data.destinationTrailName, originTrailName: data.originTrailName, dateMade: data.dateMade, timeTook: data.timeTook, userID: data.userID)
        
        return userLocation.save(on: req.db).map { userLocation }
    }
    
    /**
     * Gets all the user routes from the database
     */
    func getAllHandler(_ req: Request) async throws -> [UserRoute] {
        return try await UserRoute.query(on: req.db).all()
    }
    
    /**
     * Gets the user route with the specifed id from the database
     */
    func getHandler(_ req: Request) async throws -> UserRoute {
        guard let userRoute = try await UserRoute.find(req.parameters.get("urId"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return userRoute
    }
    
    /**
     * Deletes the user route with the specified id from the database
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let userRoute = try await getHandler(req)
        
        try await userRoute.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Deletes all the user routes from the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allUserRoutes = try await getAllHandler(req)
        
        try await allUserRoutes.delete(on: req.db)
        
        return .noContent
    }
}

struct CreateUserRoutesData: Content{
    let destinationTrailName: String
    let originTrailName: String
    let dateMade: String
    let timeTook: Int
    let userID: UUID
}
