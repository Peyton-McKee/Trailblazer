// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "34b5cc507891e62834f2893179d0f6c5"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TrailReport.self)
    ModelRegistry.register(modelType: Map.self)
  }
}