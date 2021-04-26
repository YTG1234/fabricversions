import Foundation

fileprivate let MINECRAFT_MANIFEST = "https://launchermeta.mojang.com/mc/game/version_manifest.json"
fileprivate let target = URL(string: MINECRAFT_MANIFEST)!

public var VERSION_MANIFEST: VersionManifest? = nil

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

public struct MinecraftVersion : Decodable {
  let assets: String
}

fileprivate func getVersionManifest() -> Result<VersionManifest, Error> {
  if VERSION_MANIFEST == nil {
    switch sendRequest(target: target) {
      case .failure(let error): return .failure(error)
      case .success(let data): do {
        VERSION_MANIFEST = try decoder.decode(VersionManifest.self, from: data)
      } catch {
        return .failure(error)
      }
    }
  }

  return .success(VERSION_MANIFEST!)
}

public func getLatestVersion() -> Result<String, Error> {
  switch getVersionManifest() {
    case Result.failure(let error): return .failure(error)
    case Result.success(let manifest): return .success(manifest.latest.release)
  }
}

public func getVersion(number: String) -> Result<MinecraftVersion, Error> {
  switch getVersionManifest() {
    case .failure(let error): return .failure(error)
    case .success(let manifest):
      if let first = (manifest.versions.first { $0.id == number }) {
        switch sendRequest(target: URL(string: first.url)!) {
          case .failure(let error): return .failure(error)
          case .success(let data): do {
            return .success(try decoder.decode(MinecraftVersion.self, from: data))
          } catch {
            return .failure(error)
          }
        }
      } else {
        return .failure(VersionError.runtimeError("Cound not find Minecraft version \(number)!"))
      }
  }
}
