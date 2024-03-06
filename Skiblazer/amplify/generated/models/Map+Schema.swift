// swiftlint:disable all
import Amplify
import Foundation

extension Map {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case storageKeyPrefix
    case mountainReportUrl
    case trailStatusElementId
    case liftStatusElementId
    case trailReports
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let map = Map.keys
    
    model.listPluralName = "Maps"
    model.syncPluralName = "Maps"
    
    model.attributes(
      .primaryKey(fields: [map.id])
    )
    
    model.fields(
      .field(map.id, is: .required, ofType: .string),
      .field(map.name, is: .required, ofType: .string),
      .field(map.storageKeyPrefix, is: .required, ofType: .string),
      .field(map.mountainReportUrl, is: .optional, ofType: .string),
      .field(map.trailStatusElementId, is: .optional, ofType: .string),
      .field(map.liftStatusElementId, is: .optional, ofType: .string),
      .hasMany(map.trailReports, is: .optional, ofType: TrailReport.self, associatedWith: TrailReport.keys.map),
      .field(map.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(map.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Map: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}