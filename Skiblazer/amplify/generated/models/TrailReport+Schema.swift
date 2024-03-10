// swiftlint:disable all
import Amplify
import Foundation

extension TrailReport {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case type
    case trailMadeOn
    case latitude
    case longitude
    case active
    case map
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let trailReport = TrailReport.keys
    
    model.listPluralName = "TrailReports"
    model.syncPluralName = "TrailReports"
    
    model.attributes(
      .primaryKey(fields: [trailReport.id])
    )
    
    model.fields(
      .field(trailReport.id, is: .required, ofType: .string),
      .field(trailReport.type, is: .required, ofType: .enum(type: TrailReportType.self)),
      .field(trailReport.trailMadeOn, is: .required, ofType: .string),
      .field(trailReport.latitude, is: .required, ofType: .double),
      .field(trailReport.longitude, is: .required, ofType: .double),
      .field(trailReport.active, is: .required, ofType: .bool),
      .belongsTo(trailReport.map, is: .required, ofType: Map.self, targetNames: ["mapTrailReportsId"]),
      .field(trailReport.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(trailReport.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension TrailReport: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}