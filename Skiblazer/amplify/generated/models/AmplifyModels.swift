// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "cbef760e452f3e58d5e18375fe7052d6"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TrailReport.self)
    ModelRegistry.register(modelType: Map.self)
  }
}