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

    if list {
      print("""
      Fabric Loader: \(lV.value.versionNumber)
      Yarn Mappings: \(yV.value.versionNumber)
      Fabric API: \(aV.value.versionNumber)
      """)
    }
    if buildscript {
      print("""
      \(Color(.none).attr(.bold).paint("In your Gradle buildscript:", if: colors))

      dependencies {
        minecraft()
        modImplementation()

        \(Color(.black).brighten().paint("// Fabric API", if: colors))
        modImplementation()
      }
      """)
    }
  }
}

fileprivate func exitWithErrorStatus() {
  exit(1)
}

FabricVersions.main()
