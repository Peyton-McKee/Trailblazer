// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b30dfe5ebe69e39b824ff425f9296ad8"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TrailReport.self)
    ModelRegistry.register(modelType: Map.self)
  }
}