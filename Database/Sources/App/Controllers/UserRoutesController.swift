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
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<UserRoute> {
        let data = try req.content.decode(CreateUserRoutesData.self)
        
        let userLocation = UserRoute(destinationTrailName: data.destinationTrailName, originTrailName: data.originTrailName, dateMade: data.dateMade, timeTook: data.timeTook, userID: data.userID)
        
        return userLocation.save(on: req.db).map { userLocation }
    }
    func getAllHandler(_ req: Request) -> EventLoopFuture<[UserRoute]> {
        UserRoute.query(on: req.db).all()
    }
    func getHandler(_ req: Request)
    -> EventLoopFuture<UserRoute> {
        
        UserRoute.find(req.parameters.get("urId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        UserRoute.find(req.parameters.get("urId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userRoute in
                userRoute.delete(on: req.db).transform(to: .noContent)
            }
    }
    func deleteAllHandler(_ req: Request) ->EventLoopFuture<HTTPStatus> {
        UserRoute.query(on: req.db)
            .delete(force: true).transform(to: .noContent)
    }
}

struct CreateUserRoutesData: Content{
    let destinationTrailName: String
    let originTrailName: String
    let dateMade: String
    let timeTook: Int
    let userID: UUID
}
