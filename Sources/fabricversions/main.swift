import Foundation
import ArgumentParser

// This is very procedural of me
public var options: FabricVersions? = nil

public struct FabricVersions: ParsableCommand {
  @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Output an example mod gradle.properties snippet")
  var properties = false
  
  @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Output a Gradle buildscript snippet")
  var buildscript = false
  
  @Option(name: .shortAndLong, help: "Select the Minecraft version")
  var minecraftVersion: String?
  
  @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Output a plain list of version numbers")
  var list = true
  
  @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "Verbose output")
  var verbose = false
  
  @Flag(name: .shortAndLong, inversion: .prefixedNo, help: "ANSI-colored output")
  var colors = false

  public init() {}
 
  public mutating func run() throws {
    options = self
    var mV = minecraftVersion

    if mV == nil {
      switch getLatestVersion() {
        case .success(let data): mV = data
        case .failure(let error): {
          print("Failed to fetch the latest Minecraft version")
          print(error)
          exitWithErrorStatus()
        }()
      }
    }

    // var loaderVersion: MavenStringPair? = nil
    // var yarnVersion: MavenStringPair? = nil
    // var apiVersion: MavenStringPair? = nil

    // let lGrp = DispatchGroup()
    // let yGrp = DispatchGroup()
    // let aGrp = DispatchGroup()

    let lV = AsyncGroupOptionalHolder<MavenStringPair> { (grp, ctx) in
      DispatchQueue.global().async {
        switch loaderVersionForMinecraft(mcVersion: mV!) {
          case .success(let version): ctx.set(version)
          case .failure(let error): {
            print("Failed to fetch the latest Loader version")
            print(error)
            exitWithErrorStatus()
          }()
        }
        grp.leave()
      }
    }

    let yV = AsyncGroupOptionalHolder<MavenStringPair> { (grp, ctx) in
      DispatchQueue.global().async {
        switch yarnVersionForMinecraft(mcVersion: mV!) {
          case .success(let version): ctx.set(version)
          case .failure(let error): {
            print("Failed to fetch the latest Yarn version")
            print(error)
            exitWithErrorStatus()
          }()
        }
        grp.leave()
      }
    }

    let aV = AsyncGroupOptionalHolder<MavenStringPair> { (grp, ctx) in
      DispatchQueue.global().async {
        switch apiVersionForMinecraft(mcVersion: mV!) {
          case .success(let version): ctx.set(version)
          case .failure(let error): {
            print("Failed to fetch the latest FAPI version")
            print(error)
            exitWithErrorStatus()
          }()
        }
        grp.leave()
      }
    }

    // lGrp.enter()
    // yGrp.enter()
    // aGrp.enter()

    // DispatchQueue.global().async {
    //   switch loaderVersionForMinecraft(mcVersion: mV!) {
    //     case .success(let version): loaderVersion = version
    //     case .failure(let error): {
    //       print("Failed to fetch the latest Loader version")
    //       print(error)
    //       exitWithErrorStatus()
    //     }()
    //   }
    //   lGrp.leave()
    // }

    // DispatchQueue.global().async {
    //   switch yarnVersionForMinecraft(mcVersion: mV!) {
    //     case .success(let version): yarnVersion = version
    //     case .failure(let error): {
    //       print("Failed to fetch the latest Yarn version")
    //       print(error)
    //       exitWithErrorStatus()
    //     }()
    //   }
    //   yGrp.leave()
    // }

    // DispatchQueue.global().async {
    //   switch apiVersionForMinecraft(mcVersion: mV!) {
    //     case .success(let version): apiVersion = version
    //     case .failure(let error): {
    //       print("Failed to fetch the latest FAPI version")
    //       print(error)
    //       exitWithErrorStatus()
    //     }()
    //   }
    //   aGrp.leave()
    // }

    print(lV.value)
    print(yV.value)
    print(aV.value)
  }
}

fileprivate func exitWithErrorStatus() {
  exit(1)
}

FabricVersions.main()
