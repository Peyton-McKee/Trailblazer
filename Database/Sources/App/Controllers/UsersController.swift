//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/4/22.
//

import Vapor

// 1
struct UsersController: RouteCollection {
    // 2
    func boot(routes: RoutesBuilder) throws {
        // 3
        let usersRoute = routes.grouped("api", "users")
        // 4
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.delete(":userID", use: deleteHandler)
        usersRoute.get(":userID", "trail-reports", use: getTrailReportsHandler)
        usersRoute.get(":userID", "user-locations", use: getUserLocationsHandler)
        usersRoute.get(":userID", "user-routes", use: getUserRoutesHandler)
        usersRoute.delete(use: deleteAllHandler)
        usersRoute.put(":userID", use: updateHandler)
        
    }
    
    // 5
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<User> {
        // 6
        let user = try req.content.decode(User.self)
        // 7
        return user.save(on: req.db).map { user }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<User> {
        // 4
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func getTrailReportsHandler(_ req: Request)
    -> EventLoopFuture<[TrailReport]> {
        // 2
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                // 3
                user.$trailReports.get(on: req.db)
            }
    }
    func getUserLocationsHandler(_ req: Request)
    -> EventLoopFuture<[UserLocation]> {
        // 2
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                // 3
                user.$userLocations.get(on: req.db)
            }
    }
    func updateHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let updatedUser = try req.content.decode(User.self)
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.alertSettings = updatedUser.alertSettings
                user.routingPreference = updatedUser.routingPreference
                return user.save(on: req.db).map{
                    user
                }
            }
    }
    func getUserRoutesHandler(_ req: Request)
    -> EventLoopFuture<[UserRoute]> {
        // 2
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                // 3
                user.$userRoutes.get(on: req.db)
            }
    }
    
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        User.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
    }
}
