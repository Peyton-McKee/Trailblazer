// swiftlint:disable all
import Amplify
import Foundation

public struct TrailReport: Model {
  public let id: String
  public var type: TrailReportType
  public var trailMadeOn: String
  public var active: Bool
  public var mapId: String
  public var map: Map
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      type: TrailReportType,
      trailMadeOn: String,
      active: Bool,
      mapId: String,
      map: Map) {
    self.init(id: id,
      type: type,
      trailMadeOn: trailMadeOn,
      active: active,
      mapId: mapId,
      map: map,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      type: TrailReportType,
      trailMadeOn: String,
      active: Bool,
      mapId: String,
      map: Map,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.type = type
      self.trailMadeOn = trailMadeOn
      self.active = active
      self.mapId = mapId
      self.map = map
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}