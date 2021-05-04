/*
    This file is part of FabricVersions.

    Copyright (C) 2021  YTG123

    FabricVersions is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
    print(Color16(.black).brighten().paint(strings.joined(separator: "\n"), if: options!.colors))
  }
}

public func sendRequest(target: URL) -> Result<Data, Error> {
  printVerbose("Sending request to: \(target)")
  let grp = DispatchGroup()
  var result: Data = Data()
  var errorW: Error? = nil

  grp.enter()
  URLSession.shared.dataTask(with: target) {(data, _, error) in
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
