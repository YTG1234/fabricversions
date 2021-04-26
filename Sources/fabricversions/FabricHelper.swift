import Foundation
import SwiftyXMLParser

fileprivate let FABRIC_META = "https://meta.fabricmc.net/v2"
fileprivate let FAPI_METADATA = "https://maven.fabricmc.net/net/fabricmc/fabric-api/fabric-api/maven-metadata.xml"

public struct MavenStringPair {
  public let mavenCoords: String
  public let versionNumber: String

  init(maven coords: String, version: String) {
    mavenCoords = coords
    versionNumber = version
  }

  init(from string: String) {
    self.init(maven: string, version: String(string.split(separator: ":")[2]))
  }
}

fileprivate struct FabricToolchainVersion: Decodable {
  let maven: String
  let version: String
}

public func loaderVersionForMinecraft(mcVersion: String) -> Result<MavenStringPair, Error> {
  switch sendRequest(target: URL(string: "\(FABRIC_META)/versions/loader/\(mcVersion)?limit=1")!) {
    case .failure(let error): return .failure(error)
    case .success(let data): do {
      let loaderVersion: JsonObject = try toJson((toJson((data.toJson() as JsonArray)[0]) as JsonObject)["loader"]!)
      return .success(MavenStringPair(maven: loaderVersion["maven"] as! String, version: loaderVersion["version"] as! String))
    } catch {
      return .failure(error)
    }
  }
}

public func yarnVersionForMinecraft(mcVersion: String) -> Result<MavenStringPair, Error> {
  switch sendRequest(target: URL(string: "\(FABRIC_META)/versions/yarn/\(mcVersion)?limit=1")!) {
    case .failure(let error): return .failure(error)
    case .success(let data): do {
      let yarnVersion = try decoder.decode([FabricToolchainVersion].self, from: data)[0]
      return .success(MavenStringPair(maven: yarnVersion.maven, version: yarnVersion.version))
    } catch {
      return .failure(error)
    }
  }
}

public func apiVersionForMinecraft(mcVersion: String) -> Result<MavenStringPair, Error> {
  getVersion(number: mcVersion).flatMap { version in
    switch sendRequest(target: URL(string: FAPI_METADATA)!) {
      case .failure(let error): return .failure(error)
      case .success(let data): if let first =
        XML.parse(data)["metadata", "versioning", "versions", "version"]
        .reversed()
        .first(where: { $0.text?.hasSuffix("+\(version.assets)") ?? false }) {
        return .success(MavenStringPair(maven: "net.fabricmc.fabric-api.fabric-api", version: first.text!))
      } else {
        return .failure(VersionError.runtimeError("Failed to find a FAPI version matching asset index \(version.assets)"))
      }
    }
  }
}
