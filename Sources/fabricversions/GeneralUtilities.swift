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

public func printVerbose(_ strings: String...) {
  if options!.verbose {
    print(Color(.black).brighten().paint(text: strings.joined(separator: "\n")))
  }
}

public func sendRequest(target: URL) -> Result<Data, Error> {
  printVerbose("Sending request to: \(target)")
  let grp = DispatchGroup()
  var result: Data = Data()
  var errorW: Error? = nil

  grp.enter()
  URLSession.shared.dataTask(with: target) {(data, response, error) in
    guard let data = data else {
      errorW = error!
      grp.leave()
      return
    }

    result = data
    grp.leave()
  }.resume()

  grp.wait()

  if errorW != nil { return .failure(errorW!) }
  return .success(result)
}

public extension Data {
  func toJson<T>() throws -> T {
    return try JSONSerialization.jsonObject(with: self, options: []) as! T
  }
}

public class DispatchContext<T> {
  private let holder: AsyncGroupOptionalHolder<T>

  public func set(_ value: T) {
    holder._value = value
  }

  fileprivate init(_ holder: AsyncGroupOptionalHolder<T>) {
    self.holder = holder
  }
}

public class AsyncGroupOptionalHolder<T> {
  fileprivate var _value: T? = nil
  private let group: DispatchGroup
  public var value: T {
    if _value == nil {
      group.wait()
    }
    return _value!
  }

  public init(_ initialRun: (DispatchGroup, DispatchContext<T>) -> ()) {
    let grp = DispatchGroup()
    self.group = grp

    grp.enter()
    initialRun(grp, DispatchContext(self))
  }
}
