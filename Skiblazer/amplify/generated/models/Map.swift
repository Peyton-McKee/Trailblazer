// swiftlint:disable all
import Amplify
import Foundation

public struct Map: Model {
  public let id: String
  public var name: String
  public var storageKeyPrefix: String
  public var trailReports: List<TrailReport>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      storageKeyPrefix: String,
      trailReports: List<TrailReport> = []) {
    self.init(id: id,
      name: name,
      storageKeyPrefix: storageKeyPrefix,
      trailReports: trailReports,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      storageKeyPrefix: String,
      trailReports: List<TrailReport> = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.storageKeyPrefix = storageKeyPrefix
      self.trailReports = trailReports
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}