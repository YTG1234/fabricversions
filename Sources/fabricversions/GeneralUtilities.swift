import Foundation
import FoundationNetworking

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

public func sendRequest(target: URL) -> Result<Data, Error> {
  let semaphore = DispatchSemaphore(value: 0)
  var result: Data = Data()
  var errorW: Error? = nil

  let task = URLSession.shared.dataTask(with: target) {(data, response, error) in
    guard let data = data else {
      errorW = error!
      return
    }

    result = data
    semaphore.signal()
  }

  task.resume()
  semaphore.wait()

  if errorW != nil { return .failure(errorW!) }
  return .success(result)
}

public extension Data {
  func toJson<T>() throws -> T {
    return try JSONSerialization.jsonObject(with: self, options: []) as! T
  }
}
