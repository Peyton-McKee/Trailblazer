import Vapor
import Fluent

// 1
final class Acronym: Model {
  // 2
  static let schema = "acronyms"
  
  // 3
  @ID
  var id: UUID?
  
  // 4
  @Field(key: "short")
  var short: String
  
  @Field(key: "long")
  var long: String
  
  @Parent(key: "userID")
    var user: User
  // 5
  init() {}
  
  // 6
    init(id: UUID? = nil, short: String, long: String, userID: User.IDValue) {
    self.id = id
    self.short = short
    self.long = long
    self.$user.id = userID
  }
}

extension Acronym: Content {
    
}
