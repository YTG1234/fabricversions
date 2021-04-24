import Foundation
import CombineX

fileprivate let FABRIC_META = "https://meta.fabricmc.net/v2"
fileprivate let FAPI_METADATA = "https://maven.fabricmc.net/net/fabricmc/fabric-api/fabric-api/maven-metadata.xml"

public struct MavenStringPair {
  let mavenCoords: String
  let versionNumber: String

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

public func loaderVersionForMinecraft(mcVersion: String) -> Future<MavenStringPair, Error> {
  Future { p in
    switch sendRequest(target: URL(string: "\(FABRIC_META)/versions/loader/\(mcVersion)?limit=1")!) {
      case .failure(let error): p(.failure(error))
      case .success(let data): do {
        let loaderVersion = try decoder.decode([FabricToolchainVersion].self, from: data)[0]
        p(.success(MavenStringPair(maven: loaderVersion.maven, version: loaderVersion.version)))
      } catch {
        p(.failure(error))
      }
    }
  }
}
