import Foundation

public typealias JsonObject = [String: Any]
public typealias JsonArray = [Any]

public typealias JsonString = String
public typealias JsonInt = Int
public typealias JsonDouble = Double
public typealias JsonBoolean = Bool

public let decoder = JSONDecoder()

public enum VersionError: Error {
  case runtimeError(String)
}

public func toJson<T>(_ any: Any) throws -> T {
  return any as! T
}

public extension Data {
  func toJson<T>() throws -> T {
    return try JSONSerialization.jsonObject(with: self, options: []) as! T
  }
}
