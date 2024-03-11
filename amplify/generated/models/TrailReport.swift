// swiftlint:disable all
import Amplify
import Foundation

public struct TrailReport: Model {
  public let id: String
  public var type: TrailReportType
  public var trailMadeOn: String
  public var latitude: Double
  public var longitude: Double
  public var active: Bool
  public var map: Map
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      type: TrailReportType,
      trailMadeOn: String,
      latitude: Double,
      longitude: Double,
      active: Bool,
      map: Map) {
    self.init(id: id,
      type: type,
      trailMadeOn: trailMadeOn,
      latitude: latitude,
      longitude: longitude,
      active: active,
      map: map,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      type: TrailReportType,
      trailMadeOn: String,
      latitude: Double,
      longitude: Double,
      active: Bool,
      map: Map,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.type = type
      self.trailMadeOn = trailMadeOn
      self.latitude = latitude
      self.longitude = longitude
      self.active = active
      self.map = map
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}