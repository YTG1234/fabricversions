import Foundation
import FoundationNetworking
import CombineX

fileprivate let MINECRAFT_MANIFEST = "https://launchermeta.mojang.com/mc/game/version_manifest.json"
fileprivate let target = URL(string: MINECRAFT_MANIFEST)!

public struct VersionManifest : Decodable {
  public struct LatestVersions : Decodable {
    let release: String
  }

  public struct Version : Decodable {
    public let id: String
    public let url: String
  }

  let latest: LatestVersions
  let versions: [Version]
}

fileprivate func getVersionManifest() -> Result<VersionManifest, Error> {
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
  do {
    let manifest = try decoder.decode(VersionManifest.self, from: result)
    return .success(manifest)
  } catch {
    return .failure(error)
  }
}

public func getLatestVersion() -> Future<String, Error> {
  Future {
    switch getVersionManifest() {
      case Result.failure(let error): $0(.failure(error))
      case Result.success(let manifest): $0(.success(manifest.latest.release))
    }
  }
}

public func getVersion(number: String) -> Future<VersionManifest.Version, Error> {
  Future { p in
    switch getVersionManifest() {
      case .failure(let error): p(.failure(error))
      case .success(let manifest):
        if let first = (manifest.versions.first { $0.id == number }) {
          p(.success(first))
        } else {
          p(.failure(VersionError.runtimeError("Cound not find Minecraft version \(number)!")))
        }
    }
  }
}
