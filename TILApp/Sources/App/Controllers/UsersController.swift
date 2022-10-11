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
    usersRoute.get( use: getAllHandler)
    usersRoute.get(":userID", use: getHandler)
    usersRoute.delete(":userID", use: deleteHandler)
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
    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("userID"), on: req.db)
          .unwrap(or: Abort(.notFound))
          .flatMap { user in
            user.delete(on: req.db).transform(to: .noContent)
          }
    }
    
}
