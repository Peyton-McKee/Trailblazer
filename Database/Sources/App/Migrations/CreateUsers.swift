//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/4/22.
//

import Fluent

// 1
struct CreateUser: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    database.schema("users")
      // 4
      .id()
      // 5
      .field("userName", .string, .required)
      .field("password", .string, .required)
      // 6
      .create()
  }
  
  // 7
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("users").delete()
  }
}
