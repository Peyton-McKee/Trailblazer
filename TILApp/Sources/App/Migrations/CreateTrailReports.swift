//
//  File.swift
//  
//
//  Created by Peyton McKee on 10/19/22.
//

import Fluent

struct CreateTrailReports: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    database.schema("trailReports")
      // 4
      .id()
      // 5
      .field("type", .string, .required)
      .field("location", .string, .required)
      // 6
      .create()
  }
  
  // 7
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("trailReports").delete()
  }
}
