//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreateTrailReportInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, mapTrailReportsId: GraphQLID) {
    graphQLMap = ["id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "mapTrailReportsId": mapTrailReportsId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: TrailReportType {
    get {
      return graphQLMap["type"] as! TrailReportType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var trailMadeOn: String {
    get {
      return graphQLMap["trailMadeOn"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailMadeOn")
    }
  }

  public var latitude: Double {
    get {
      return graphQLMap["latitude"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: Double {
    get {
      return graphQLMap["longitude"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var active: Bool {
    get {
      return graphQLMap["active"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "active")
    }
  }

  public var mapId: GraphQLID {
    get {
      return graphQLMap["mapId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapId")
    }
  }

  public var mapTrailReportsId: GraphQLID {
    get {
      return graphQLMap["mapTrailReportsId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapTrailReportsId")
    }
  }
}

public enum TrailReportType: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case moguls
  case icy
  case powder
  case thinCover
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MOGULS": self = .moguls
      case "ICY": self = .icy
      case "POWDER": self = .powder
      case "THIN_COVER": self = .thinCover
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .moguls: return "MOGULS"
      case .icy: return "ICY"
      case .powder: return "POWDER"
      case .thinCover: return "THIN_COVER"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: TrailReportType, rhs: TrailReportType) -> Bool {
    switch (lhs, rhs) {
      case (.moguls, .moguls): return true
      case (.icy, .icy): return true
      case (.powder, .powder): return true
      case (.thinCover, .thinCover): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelTrailReportConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(type: ModelTrailReportTypeInput? = nil, trailMadeOn: ModelStringInput? = nil, latitude: ModelFloatInput? = nil, longitude: ModelFloatInput? = nil, active: ModelBooleanInput? = nil, mapId: ModelIDInput? = nil, and: [ModelTrailReportConditionInput?]? = nil, or: [ModelTrailReportConditionInput?]? = nil, not: ModelTrailReportConditionInput? = nil, mapTrailReportsId: ModelIDInput? = nil) {
    graphQLMap = ["type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "and": and, "or": or, "not": not, "mapTrailReportsId": mapTrailReportsId]
  }

  public var type: ModelTrailReportTypeInput? {
    get {
      return graphQLMap["type"] as! ModelTrailReportTypeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var trailMadeOn: ModelStringInput? {
    get {
      return graphQLMap["trailMadeOn"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailMadeOn")
    }
  }

  public var latitude: ModelFloatInput? {
    get {
      return graphQLMap["latitude"] as! ModelFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: ModelFloatInput? {
    get {
      return graphQLMap["longitude"] as! ModelFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var active: ModelBooleanInput? {
    get {
      return graphQLMap["active"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "active")
    }
  }

  public var mapId: ModelIDInput? {
    get {
      return graphQLMap["mapId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapId")
    }
  }

  public var and: [ModelTrailReportConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelTrailReportConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelTrailReportConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelTrailReportConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelTrailReportConditionInput? {
    get {
      return graphQLMap["not"] as! ModelTrailReportConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var mapTrailReportsId: ModelIDInput? {
    get {
      return graphQLMap["mapTrailReportsId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapTrailReportsId")
    }
  }
}

public struct ModelTrailReportTypeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: TrailReportType? = nil, ne: TrailReportType? = nil) {
    graphQLMap = ["eq": eq, "ne": ne]
  }

  public var eq: TrailReportType? {
    get {
      return graphQLMap["eq"] as! TrailReportType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var ne: TrailReportType? {
    get {
      return graphQLMap["ne"] as! TrailReportType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct ModelFloatInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Double? = nil, eq: Double? = nil, le: Double? = nil, lt: Double? = nil, ge: Double? = nil, gt: Double? = nil, between: [Double?]? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Double? {
    get {
      return graphQLMap["ne"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Double? {
    get {
      return graphQLMap["eq"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Double? {
    get {
      return graphQLMap["le"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Double? {
    get {
      return graphQLMap["lt"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Double? {
    get {
      return graphQLMap["ge"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Double? {
    get {
      return graphQLMap["gt"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Double?]? {
    get {
      return graphQLMap["between"] as! [Double?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct ModelBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdateTrailReportInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: TrailReportType? = nil, trailMadeOn: String? = nil, latitude: Double? = nil, longitude: Double? = nil, active: Bool? = nil, mapId: GraphQLID? = nil, mapTrailReportsId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "mapTrailReportsId": mapTrailReportsId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: TrailReportType? {
    get {
      return graphQLMap["type"] as! TrailReportType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var trailMadeOn: String? {
    get {
      return graphQLMap["trailMadeOn"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailMadeOn")
    }
  }

  public var latitude: Double? {
    get {
      return graphQLMap["latitude"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: Double? {
    get {
      return graphQLMap["longitude"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var active: Bool? {
    get {
      return graphQLMap["active"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "active")
    }
  }

  public var mapId: GraphQLID? {
    get {
      return graphQLMap["mapId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapId")
    }
  }

  public var mapTrailReportsId: GraphQLID? {
    get {
      return graphQLMap["mapTrailReportsId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapTrailReportsId")
    }
  }
}

public struct DeleteTrailReportInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateMapInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil) {
    graphQLMap = ["id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var storageKeyPrefix: String {
    get {
      return graphQLMap["storageKeyPrefix"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageKeyPrefix")
    }
  }

  public var mountainReportUrl: String? {
    get {
      return graphQLMap["mountainReportUrl"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mountainReportUrl")
    }
  }

  public var trailStatusElementId: String? {
    get {
      return graphQLMap["trailStatusElementId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailStatusElementId")
    }
  }

  public var liftStatusElementId: String? {
    get {
      return graphQLMap["liftStatusElementId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "liftStatusElementId")
    }
  }
}

public struct ModelMapConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: ModelStringInput? = nil, storageKeyPrefix: ModelStringInput? = nil, mountainReportUrl: ModelStringInput? = nil, trailStatusElementId: ModelStringInput? = nil, liftStatusElementId: ModelStringInput? = nil, and: [ModelMapConditionInput?]? = nil, or: [ModelMapConditionInput?]? = nil, not: ModelMapConditionInput? = nil) {
    graphQLMap = ["name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "and": and, "or": or, "not": not]
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var storageKeyPrefix: ModelStringInput? {
    get {
      return graphQLMap["storageKeyPrefix"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageKeyPrefix")
    }
  }

  public var mountainReportUrl: ModelStringInput? {
    get {
      return graphQLMap["mountainReportUrl"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mountainReportUrl")
    }
  }

  public var trailStatusElementId: ModelStringInput? {
    get {
      return graphQLMap["trailStatusElementId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailStatusElementId")
    }
  }

  public var liftStatusElementId: ModelStringInput? {
    get {
      return graphQLMap["liftStatusElementId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "liftStatusElementId")
    }
  }

  public var and: [ModelMapConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelMapConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelMapConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelMapConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelMapConditionInput? {
    get {
      return graphQLMap["not"] as! ModelMapConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateMapInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, name: String? = nil, storageKeyPrefix: String? = nil, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil) {
    graphQLMap = ["id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var storageKeyPrefix: String? {
    get {
      return graphQLMap["storageKeyPrefix"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageKeyPrefix")
    }
  }

  public var mountainReportUrl: String? {
    get {
      return graphQLMap["mountainReportUrl"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mountainReportUrl")
    }
  }

  public var trailStatusElementId: String? {
    get {
      return graphQLMap["trailStatusElementId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailStatusElementId")
    }
  }

  public var liftStatusElementId: String? {
    get {
      return graphQLMap["liftStatusElementId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "liftStatusElementId")
    }
  }
}

public struct DeleteMapInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelTrailReportFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, type: ModelTrailReportTypeInput? = nil, trailMadeOn: ModelStringInput? = nil, latitude: ModelFloatInput? = nil, longitude: ModelFloatInput? = nil, active: ModelBooleanInput? = nil, mapId: ModelIDInput? = nil, and: [ModelTrailReportFilterInput?]? = nil, or: [ModelTrailReportFilterInput?]? = nil, not: ModelTrailReportFilterInput? = nil, mapTrailReportsId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "and": and, "or": or, "not": not, "mapTrailReportsId": mapTrailReportsId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelTrailReportTypeInput? {
    get {
      return graphQLMap["type"] as! ModelTrailReportTypeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var trailMadeOn: ModelStringInput? {
    get {
      return graphQLMap["trailMadeOn"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailMadeOn")
    }
  }

  public var latitude: ModelFloatInput? {
    get {
      return graphQLMap["latitude"] as! ModelFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: ModelFloatInput? {
    get {
      return graphQLMap["longitude"] as! ModelFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var active: ModelBooleanInput? {
    get {
      return graphQLMap["active"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "active")
    }
  }

  public var mapId: ModelIDInput? {
    get {
      return graphQLMap["mapId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapId")
    }
  }

  public var and: [ModelTrailReportFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelTrailReportFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelTrailReportFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelTrailReportFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelTrailReportFilterInput? {
    get {
      return graphQLMap["not"] as! ModelTrailReportFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var mapTrailReportsId: ModelIDInput? {
    get {
      return graphQLMap["mapTrailReportsId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapTrailReportsId")
    }
  }
}

public struct ModelMapFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, name: ModelStringInput? = nil, storageKeyPrefix: ModelStringInput? = nil, mountainReportUrl: ModelStringInput? = nil, trailStatusElementId: ModelStringInput? = nil, liftStatusElementId: ModelStringInput? = nil, and: [ModelMapFilterInput?]? = nil, or: [ModelMapFilterInput?]? = nil, not: ModelMapFilterInput? = nil) {
    graphQLMap = ["id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var storageKeyPrefix: ModelStringInput? {
    get {
      return graphQLMap["storageKeyPrefix"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageKeyPrefix")
    }
  }

  public var mountainReportUrl: ModelStringInput? {
    get {
      return graphQLMap["mountainReportUrl"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mountainReportUrl")
    }
  }

  public var trailStatusElementId: ModelStringInput? {
    get {
      return graphQLMap["trailStatusElementId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailStatusElementId")
    }
  }

  public var liftStatusElementId: ModelStringInput? {
    get {
      return graphQLMap["liftStatusElementId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "liftStatusElementId")
    }
  }

  public var and: [ModelMapFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelMapFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelMapFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelMapFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelMapFilterInput? {
    get {
      return graphQLMap["not"] as! ModelMapFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelSubscriptionTrailReportFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, type: ModelSubscriptionStringInput? = nil, trailMadeOn: ModelSubscriptionStringInput? = nil, latitude: ModelSubscriptionFloatInput? = nil, longitude: ModelSubscriptionFloatInput? = nil, active: ModelSubscriptionBooleanInput? = nil, mapId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionTrailReportFilterInput?]? = nil, or: [ModelSubscriptionTrailReportFilterInput?]? = nil) {
    graphQLMap = ["id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["type"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var trailMadeOn: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["trailMadeOn"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailMadeOn")
    }
  }

  public var latitude: ModelSubscriptionFloatInput? {
    get {
      return graphQLMap["latitude"] as! ModelSubscriptionFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: ModelSubscriptionFloatInput? {
    get {
      return graphQLMap["longitude"] as! ModelSubscriptionFloatInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var active: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["active"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "active")
    }
  }

  public var mapId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["mapId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mapId")
    }
  }

  public var and: [ModelSubscriptionTrailReportFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionTrailReportFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionTrailReportFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionTrailReportFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionFloatInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Double? = nil, eq: Double? = nil, le: Double? = nil, lt: Double? = nil, ge: Double? = nil, gt: Double? = nil, between: [Double?]? = nil, `in`: [Double?]? = nil, notIn: [Double?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "in": `in`, "notIn": notIn]
  }

  public var ne: Double? {
    get {
      return graphQLMap["ne"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Double? {
    get {
      return graphQLMap["eq"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Double? {
    get {
      return graphQLMap["le"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Double? {
    get {
      return graphQLMap["lt"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Double? {
    get {
      return graphQLMap["ge"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Double? {
    get {
      return graphQLMap["gt"] as! Double?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Double?]? {
    get {
      return graphQLMap["between"] as! [Double?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var `in`: [Double?]? {
    get {
      return graphQLMap["in"] as! [Double?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [Double?]? {
    get {
      return graphQLMap["notIn"] as! [Double?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil) {
    graphQLMap = ["ne": ne, "eq": eq]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }
}

public struct ModelSubscriptionMapFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, name: ModelSubscriptionStringInput? = nil, storageKeyPrefix: ModelSubscriptionStringInput? = nil, mountainReportUrl: ModelSubscriptionStringInput? = nil, trailStatusElementId: ModelSubscriptionStringInput? = nil, liftStatusElementId: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionMapFilterInput?]? = nil, or: [ModelSubscriptionMapFilterInput?]? = nil) {
    graphQLMap = ["id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var storageKeyPrefix: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["storageKeyPrefix"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageKeyPrefix")
    }
  }

  public var mountainReportUrl: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["mountainReportUrl"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mountainReportUrl")
    }
  }

  public var trailStatusElementId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["trailStatusElementId"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trailStatusElementId")
    }
  }

  public var liftStatusElementId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["liftStatusElementId"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "liftStatusElementId")
    }
  }

  public var and: [ModelSubscriptionMapFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionMapFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionMapFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionMapFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public final class CreateTrailReportMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateTrailReport($input: CreateTrailReportInput!, $condition: ModelTrailReportConditionInput) {\n  createTrailReport(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var input: CreateTrailReportInput
  public var condition: ModelTrailReportConditionInput?

  public init(input: CreateTrailReportInput, condition: ModelTrailReportConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createTrailReport", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createTrailReport: CreateTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createTrailReport": createTrailReport.flatMap { $0.snapshot }])
    }

    public var createTrailReport: CreateTrailReport? {
      get {
        return (snapshot["createTrailReport"] as? Snapshot).flatMap { CreateTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createTrailReport")
      }
    }

    public struct CreateTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class UpdateTrailReportMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateTrailReport($input: UpdateTrailReportInput!, $condition: ModelTrailReportConditionInput) {\n  updateTrailReport(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var input: UpdateTrailReportInput
  public var condition: ModelTrailReportConditionInput?

  public init(input: UpdateTrailReportInput, condition: ModelTrailReportConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateTrailReport", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateTrailReport: UpdateTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateTrailReport": updateTrailReport.flatMap { $0.snapshot }])
    }

    public var updateTrailReport: UpdateTrailReport? {
      get {
        return (snapshot["updateTrailReport"] as? Snapshot).flatMap { UpdateTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateTrailReport")
      }
    }

    public struct UpdateTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class DeleteTrailReportMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteTrailReport($input: DeleteTrailReportInput!, $condition: ModelTrailReportConditionInput) {\n  deleteTrailReport(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var input: DeleteTrailReportInput
  public var condition: ModelTrailReportConditionInput?

  public init(input: DeleteTrailReportInput, condition: ModelTrailReportConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteTrailReport", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteTrailReport: DeleteTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteTrailReport": deleteTrailReport.flatMap { $0.snapshot }])
    }

    public var deleteTrailReport: DeleteTrailReport? {
      get {
        return (snapshot["deleteTrailReport"] as? Snapshot).flatMap { DeleteTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteTrailReport")
      }
    }

    public struct DeleteTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CreateMapMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateMap($input: CreateMapInput!, $condition: ModelMapConditionInput) {\n  createMap(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateMapInput
  public var condition: ModelMapConditionInput?

  public init(input: CreateMapInput, condition: ModelMapConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createMap", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createMap: CreateMap? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createMap": createMap.flatMap { $0.snapshot }])
    }

    public var createMap: CreateMap? {
      get {
        return (snapshot["createMap"] as? Snapshot).flatMap { CreateMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createMap")
      }
    }

    public struct CreateMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class UpdateMapMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateMap($input: UpdateMapInput!, $condition: ModelMapConditionInput) {\n  updateMap(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateMapInput
  public var condition: ModelMapConditionInput?

  public init(input: UpdateMapInput, condition: ModelMapConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateMap", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateMap: UpdateMap? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateMap": updateMap.flatMap { $0.snapshot }])
    }

    public var updateMap: UpdateMap? {
      get {
        return (snapshot["updateMap"] as? Snapshot).flatMap { UpdateMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateMap")
      }
    }

    public struct UpdateMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class DeleteMapMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteMap($input: DeleteMapInput!, $condition: ModelMapConditionInput) {\n  deleteMap(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteMapInput
  public var condition: ModelMapConditionInput?

  public init(input: DeleteMapInput, condition: ModelMapConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteMap", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteMap: DeleteMap? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteMap": deleteMap.flatMap { $0.snapshot }])
    }

    public var deleteMap: DeleteMap? {
      get {
        return (snapshot["deleteMap"] as? Snapshot).flatMap { DeleteMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteMap")
      }
    }

    public struct DeleteMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class GetTrailReportQuery: GraphQLQuery {
  public static let operationString =
    "query GetTrailReport($id: ID!) {\n  getTrailReport(id: $id) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getTrailReport", arguments: ["id": GraphQLVariable("id")], type: .object(GetTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getTrailReport: GetTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Query", "getTrailReport": getTrailReport.flatMap { $0.snapshot }])
    }

    public var getTrailReport: GetTrailReport? {
      get {
        return (snapshot["getTrailReport"] as? Snapshot).flatMap { GetTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getTrailReport")
      }
    }

    public struct GetTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ListTrailReportsQuery: GraphQLQuery {
  public static let operationString =
    "query ListTrailReports($filter: ModelTrailReportFilterInput, $limit: Int, $nextToken: String) {\n  listTrailReports(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      trailMadeOn\n      latitude\n      longitude\n      active\n      mapId\n      createdAt\n      updatedAt\n      mapTrailReportsId\n    }\n    nextToken\n  }\n}"

  public var filter: ModelTrailReportFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelTrailReportFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listTrailReports", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listTrailReports: ListTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Query", "listTrailReports": listTrailReports.flatMap { $0.snapshot }])
    }

    public var listTrailReports: ListTrailReport? {
      get {
        return (snapshot["listTrailReports"] as? Snapshot).flatMap { ListTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listTrailReports")
      }
    }

    public struct ListTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelTrailReportConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelTrailReportConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["TrailReport"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
          GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
          GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
          self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: TrailReportType {
          get {
            return snapshot["type"]! as! TrailReportType
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var trailMadeOn: String {
          get {
            return snapshot["trailMadeOn"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailMadeOn")
          }
        }

        public var latitude: Double {
          get {
            return snapshot["latitude"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: Double {
          get {
            return snapshot["longitude"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }

        public var active: Bool {
          get {
            return snapshot["active"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "active")
          }
        }

        public var mapId: GraphQLID {
          get {
            return snapshot["mapId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "mapId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var mapTrailReportsId: GraphQLID {
          get {
            return snapshot["mapTrailReportsId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
          }
        }
      }
    }
  }
}

public final class GetMapQuery: GraphQLQuery {
  public static let operationString =
    "query GetMap($id: ID!) {\n  getMap(id: $id) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getMap", arguments: ["id": GraphQLVariable("id")], type: .object(GetMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getMap: GetMap? = nil) {
      self.init(snapshot: ["__typename": "Query", "getMap": getMap.flatMap { $0.snapshot }])
    }

    public var getMap: GetMap? {
      get {
        return (snapshot["getMap"] as? Snapshot).flatMap { GetMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getMap")
      }
    }

    public struct GetMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class ListMapsQuery: GraphQLQuery {
  public static let operationString =
    "query ListMaps($filter: ModelMapFilterInput, $limit: Int, $nextToken: String) {\n  listMaps(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelMapFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelMapFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listMaps", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listMaps: ListMap? = nil) {
      self.init(snapshot: ["__typename": "Query", "listMaps": listMaps.flatMap { $0.snapshot }])
    }

    public var listMaps: ListMap? {
      get {
        return (snapshot["listMaps"] as? Snapshot).flatMap { ListMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listMaps")
      }
    }

    public struct ListMap: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelMapConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelMapConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateTrailReportSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateTrailReport($filter: ModelSubscriptionTrailReportFilterInput) {\n  onCreateTrailReport(filter: $filter) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var filter: ModelSubscriptionTrailReportFilterInput?

  public init(filter: ModelSubscriptionTrailReportFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateTrailReport", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateTrailReport: OnCreateTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateTrailReport": onCreateTrailReport.flatMap { $0.snapshot }])
    }

    public var onCreateTrailReport: OnCreateTrailReport? {
      get {
        return (snapshot["onCreateTrailReport"] as? Snapshot).flatMap { OnCreateTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateTrailReport")
      }
    }

    public struct OnCreateTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdateTrailReportSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateTrailReport($filter: ModelSubscriptionTrailReportFilterInput) {\n  onUpdateTrailReport(filter: $filter) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var filter: ModelSubscriptionTrailReportFilterInput?

  public init(filter: ModelSubscriptionTrailReportFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateTrailReport", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateTrailReport: OnUpdateTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateTrailReport": onUpdateTrailReport.flatMap { $0.snapshot }])
    }

    public var onUpdateTrailReport: OnUpdateTrailReport? {
      get {
        return (snapshot["onUpdateTrailReport"] as? Snapshot).flatMap { OnUpdateTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateTrailReport")
      }
    }

    public struct OnUpdateTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnDeleteTrailReportSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteTrailReport($filter: ModelSubscriptionTrailReportFilterInput) {\n  onDeleteTrailReport(filter: $filter) {\n    __typename\n    id\n    type\n    trailMadeOn\n    latitude\n    longitude\n    active\n    mapId\n    map {\n      __typename\n      id\n      name\n      storageKeyPrefix\n      mountainReportUrl\n      trailStatusElementId\n      liftStatusElementId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n    mapTrailReportsId\n  }\n}"

  public var filter: ModelSubscriptionTrailReportFilterInput?

  public init(filter: ModelSubscriptionTrailReportFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteTrailReport", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteTrailReport.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteTrailReport: OnDeleteTrailReport? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteTrailReport": onDeleteTrailReport.flatMap { $0.snapshot }])
    }

    public var onDeleteTrailReport: OnDeleteTrailReport? {
      get {
        return (snapshot["onDeleteTrailReport"] as? Snapshot).flatMap { OnDeleteTrailReport(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteTrailReport")
      }
    }

    public struct OnDeleteTrailReport: GraphQLSelectionSet {
      public static let possibleTypes = ["TrailReport"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(TrailReportType.self))),
        GraphQLField("trailMadeOn", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("active", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mapId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("map", type: .nonNull(.object(Map.selections))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("mapTrailReportsId", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: TrailReportType, trailMadeOn: String, latitude: Double, longitude: Double, active: Bool, mapId: GraphQLID, map: Map, createdAt: String, updatedAt: String, mapTrailReportsId: GraphQLID) {
        self.init(snapshot: ["__typename": "TrailReport", "id": id, "type": type, "trailMadeOn": trailMadeOn, "latitude": latitude, "longitude": longitude, "active": active, "mapId": mapId, "map": map.snapshot, "createdAt": createdAt, "updatedAt": updatedAt, "mapTrailReportsId": mapTrailReportsId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: TrailReportType {
        get {
          return snapshot["type"]! as! TrailReportType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var trailMadeOn: String {
        get {
          return snapshot["trailMadeOn"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailMadeOn")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var active: Bool {
        get {
          return snapshot["active"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "active")
        }
      }

      public var mapId: GraphQLID {
        get {
          return snapshot["mapId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapId")
        }
      }

      public var map: Map {
        get {
          return Map(snapshot: snapshot["map"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "map")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var mapTrailReportsId: GraphQLID {
        get {
          return snapshot["mapTrailReportsId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "mapTrailReportsId")
        }
      }

      public struct Map: GraphQLSelectionSet {
        public static let possibleTypes = ["Map"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
          GraphQLField("mountainReportUrl", type: .scalar(String.self)),
          GraphQLField("trailStatusElementId", type: .scalar(String.self)),
          GraphQLField("liftStatusElementId", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var storageKeyPrefix: String {
          get {
            return snapshot["storageKeyPrefix"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
          }
        }

        public var mountainReportUrl: String? {
          get {
            return snapshot["mountainReportUrl"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mountainReportUrl")
          }
        }

        public var trailStatusElementId: String? {
          get {
            return snapshot["trailStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "trailStatusElementId")
          }
        }

        public var liftStatusElementId: String? {
          get {
            return snapshot["liftStatusElementId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "liftStatusElementId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateMapSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateMap($filter: ModelSubscriptionMapFilterInput) {\n  onCreateMap(filter: $filter) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMapFilterInput?

  public init(filter: ModelSubscriptionMapFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateMap", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateMap: OnCreateMap? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateMap": onCreateMap.flatMap { $0.snapshot }])
    }

    public var onCreateMap: OnCreateMap? {
      get {
        return (snapshot["onCreateMap"] as? Snapshot).flatMap { OnCreateMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateMap")
      }
    }

    public struct OnCreateMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnUpdateMapSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateMap($filter: ModelSubscriptionMapFilterInput) {\n  onUpdateMap(filter: $filter) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMapFilterInput?

  public init(filter: ModelSubscriptionMapFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateMap", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateMap: OnUpdateMap? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateMap": onUpdateMap.flatMap { $0.snapshot }])
    }

    public var onUpdateMap: OnUpdateMap? {
      get {
        return (snapshot["onUpdateMap"] as? Snapshot).flatMap { OnUpdateMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateMap")
      }
    }

    public struct OnUpdateMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnDeleteMapSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteMap($filter: ModelSubscriptionMapFilterInput) {\n  onDeleteMap(filter: $filter) {\n    __typename\n    id\n    name\n    storageKeyPrefix\n    mountainReportUrl\n    trailStatusElementId\n    liftStatusElementId\n    trailReports {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMapFilterInput?

  public init(filter: ModelSubscriptionMapFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteMap", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteMap.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteMap: OnDeleteMap? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteMap": onDeleteMap.flatMap { $0.snapshot }])
    }

    public var onDeleteMap: OnDeleteMap? {
      get {
        return (snapshot["onDeleteMap"] as? Snapshot).flatMap { OnDeleteMap(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteMap")
      }
    }

    public struct OnDeleteMap: GraphQLSelectionSet {
      public static let possibleTypes = ["Map"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("storageKeyPrefix", type: .nonNull(.scalar(String.self))),
        GraphQLField("mountainReportUrl", type: .scalar(String.self)),
        GraphQLField("trailStatusElementId", type: .scalar(String.self)),
        GraphQLField("liftStatusElementId", type: .scalar(String.self)),
        GraphQLField("trailReports", type: .object(TrailReport.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, storageKeyPrefix: String, mountainReportUrl: String? = nil, trailStatusElementId: String? = nil, liftStatusElementId: String? = nil, trailReports: TrailReport? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Map", "id": id, "name": name, "storageKeyPrefix": storageKeyPrefix, "mountainReportUrl": mountainReportUrl, "trailStatusElementId": trailStatusElementId, "liftStatusElementId": liftStatusElementId, "trailReports": trailReports.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var storageKeyPrefix: String {
        get {
          return snapshot["storageKeyPrefix"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "storageKeyPrefix")
        }
      }

      public var mountainReportUrl: String? {
        get {
          return snapshot["mountainReportUrl"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "mountainReportUrl")
        }
      }

      public var trailStatusElementId: String? {
        get {
          return snapshot["trailStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "trailStatusElementId")
        }
      }

      public var liftStatusElementId: String? {
        get {
          return snapshot["liftStatusElementId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "liftStatusElementId")
        }
      }

      public var trailReports: TrailReport? {
        get {
          return (snapshot["trailReports"] as? Snapshot).flatMap { TrailReport(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "trailReports")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct TrailReport: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelTrailReportConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelTrailReportConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}