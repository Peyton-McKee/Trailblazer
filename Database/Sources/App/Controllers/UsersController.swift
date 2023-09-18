//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/4/22.
//

import Vapor
import Fluent

struct UserSignUp: Content {
    let username: String
    let password: String
    let alertSettings: [String]
    let routingPreference: String
}
extension UserSignUp: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}

struct UsersController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.delete(":userID", use: deleteHandler)
        usersRoute.get(":userID", "trail-reports", use: getTrailReportsHandler)
        usersRoute.get(":userID", "user-locations", use: getUserLocationsHandler)
        usersRoute.get(":userID", "user-routes", use: getUserRoutesHandler)
        usersRoute.delete(use: deleteAllHandler)
        usersRoute.put(":userID", use: updateHandler)
        
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login") { req -> User in
            try req.auth.require(User.self)
        }
        
    }
    
    /**
     * Validates and creates a user in the database
     */
    func createHandler(_ req: Request) async throws -> User {
        try UserSignUp.validate(content: req)
        let userSignup = try req.content.decode(UserSignUp.self)
        let user = try User.create(from: userSignup)
        
        if (try await doesUserExist(userSignup.username, req: req)) {
            throw Abort(.custom(code: 400, reasonPhrase: UserError.usernameTaken.reason))
        }
        
        try await user.save(on: req.db)
        
        return user
    }
    
    /**
     * Gets all the users from the database
     */
    func getAllHandler(_ req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }
    
    /**
     * Gets a single user from the database
     */
    func getHandler(_ req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return user
    }
    
    /**
     * Gets all of the users trail reports
     */
    func getTrailReportsHandler(_ req: Request) async throws -> [TrailReport] {
        let user = try await getHandler(req)
        
        return try await user.$trailReports.get(on: req.db)
    }
    
    /**
     * Gets all the users userLocations
     */
    func getUserLocationsHandler(_ req: Request) async throws -> [UserLocation] {
        let user = try await getHandler(req)
        
        return try await user.$userLocations.get(on: req.db)
    }
    
    /**
     * Updates the users alert and routing preferences
     */
    func updateHandler(_ req: Request) async throws -> User {
        let updatedUser = try req.content.decode(User.self)
        let currentUser = try await getHandler(req)
        
        currentUser.alertSettings = updatedUser.alertSettings
        currentUser.routingPreference = updatedUser.routingPreference
        try await currentUser.save(on: req.db)
        
        return currentUser
    }
    
    /**
     * Gets all of the users routes
     */
    func getUserRoutesHandler(_ req: Request) async throws -> [UserRoute] {
        let user = try await getHandler(req)
        
        return try await user.$userRoutes.get(on: req.db)
    }
    
    /**
     * Deletes the user from the database
     */
    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        let user = try await getHandler(req)
        
        try await user.delete(on: req.db)
            
        return .noContent
    }
    
    /**
     * Deletes all the users stored in the database
     */
    func deleteAllHandler(_ req: Request) async throws -> HTTPStatus {
        let allUsers = try await getAllHandler(req)
        
        try await allUsers.delete(on: req.db)
        
        return .noContent
    }
    
    /**
     * Checks if the users username already exists in the database, returns true if it does
     */
    func doesUserExist(_ username: String, req: Request) async throws -> Bool {
        return try await (User.query(on: req.db).filter(\.$username == username).first() != nil)
        
    }
}
