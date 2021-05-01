import Foundation
import SwiftyXMLParser

fileprivate let FABRIC_META = "https://meta.fabricmc.net/v2"
fileprivate let FAPI_METADATA = "https://maven.fabricmc.net/net/fabricmc/fabric-api/fabric-api/maven-metadata.xml"

public struct MavenVersionPair : Equatable, Decodable {
  public let maven: String
  public let version: String
}

public extension MavenVersionPair {
  init(from string: String) {
    self.init(maven: string, version: String(string.split(separator: ":")[2]))
  }
}

public func loaderVersionForMinecraft(mcVersion: String) -> Result<MavenVersionPair, Error> {
  switch sendRequest(target: URL(string: "\(FABRIC_META)/versions/loader/\(mcVersion)?limit=1")!) {
    case .failure(let error): return .failure(error)
    case .success(let data): do {
      let loaderVersion: JsonObject = try toJson((toJson((data.toJson() as JsonArray)[0]) as JsonObject)["loader"]!)
      return .success(MavenVersionPair(maven: loaderVersion["maven"] as! String, version: loaderVersion["version"] as! String))
    } catch {
      return .failure(error)
    }
  }
}

public func yarnVersionForMinecraft(mcVersion: String) -> Result<MavenVersionPair, Error> {
  switch sendRequest(target: URL(string: "\(FABRIC_META)/versions/yarn/\(mcVersion)?limit=1")!) {
    case .failure(let error): return .failure(error)
    case .success(let data): do {
      return .success(try decoder.decode([MavenVersionPair].self, from: data)[0])
    } catch {
      return .failure(error)
    }
  }
}

public func apiVersionForMinecraft(mcVersion: String) -> Result<MavenVersionPair, Error> {
  getVersion(number: mcVersion).flatMap { version in
    switch sendRequest(target: URL(string: FAPI_METADATA)!) {
      case .failure(let error): return .failure(error)
      case .success(let data): if let first =
        XML.parse(data)["metadata", "versioning", "versions", "version"]
        .reversed()
        .first(where: { $0.text?.hasSuffix("+\(version.assets)") ?? false }) {
        return .success(MavenVersionPair(from: "net.fabricmc.fabric-api:fabric-api:\(first.text!)"))
      } else {
        return .failure(VersionError.runtimeError("Failed to find a FAPI version matching asset index \(version.assets)"))
      }
    }
  }
}
