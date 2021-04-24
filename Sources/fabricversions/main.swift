import Foundation
import ArgumentParser
import CombineX

struct FabricVersions: ParsableCommand {
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
 
  mutating func run() throws {
    let mcVer = minecraftVersion

    let _ = (
      mcVer == nil ?
      getLatestVersion() :
      Future { $0(.success(mcVer!)) }
    ).flatMap { version in
      getVersion(number: version)
    }.flatMap { version in
      Future<(), Never> {
        print(version)
        $0(.success(()))
      }
    }.sink { completion in
      switch completion {
        case .failure(let error): {
          print("Error occured")
          print(error)
        }()
        case .finished: ()
      }
    } receiveValue: {}

    // more futures
  }
}

FabricVersions.main()
