import Foundation
import FoundationNetworking
import CombineX

fileprivate let MINECRAFT_MANIFEST = "https://launchermeta.mojang.com/mc/game/version_manifest.json"

public func getLatestVersion() -> Future<String, Error> {
  return Future { p in
    let target = URL(string: MINECRAFT_MANIFEST)!
    let semaphore = DispatchSemaphore(value: 0)

    var result: Data = Data()
    
    let task = URLSession.shared.dataTask(with: target) {(data, response, error) in
      guard let data = data else {
        p(.failure(error!))
        return
      }

      result = data
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()

    let decoder = JSONDecoder()
    
    struct MinecraftManifest: Decodable {
      struct Latest: Decodable {
        let release: String
      }
    
      let latest: Latest
    }

    do {
      let res = try decoder.decode(MinecraftManifest.self, from: result).latest.release
      p(.success(res))
    } catch {
      p(.failure(error))
    }
  }
}
