// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7291c639bd15b84a622a02d8f09b8e54"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TrailReport.self)
    ModelRegistry.register(modelType: Map.self)
  }
}