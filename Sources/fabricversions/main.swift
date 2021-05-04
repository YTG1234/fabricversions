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

  @Flag(name: .long, help: "Don't show the Fabric API version. This option is here because this takes the longest to fetch.")
  var noApi = false

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

    let lV = AsyncGroupOptionalHolder<MavenVersionPair> { (grp, ctx) in
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

    let yV = AsyncGroupOptionalHolder<MavenVersionPair> { (grp, ctx) in
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

    let aV = AsyncGroupOptionalHolder<MavenVersionPair> { (grp, ctx) in
      if noApi {
        grp.leave()
        return
      }

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

    var printed = false

    if list {
      print("""
      Fabric Loader: \(lV.value.version)
      Yarn Mappings: \(yV.value.version)\(!noApi ? "\nFabric API: \(aV.value.version)" : "")
      """)

      printed = true
    }

    if buildscript {
      let stringColor = Color16(.red).brighten()

      if printed { print() }
      print("""
      \(Color16(.none).attr(.bold).paint("In your Gradle buildscript:", if: colors))
      dependencies {
          minecraft(\(stringColor.paint("\"com.mojang:minecraft:\(mV!)\"", if: colors)))
          mappings(\(stringColor.paint("\"\(yV.value.maven)\"", if: colors)))
          modImplementation(\(stringColor.paint("\"\(lV.value.maven)\"", if: colors)))\(!noApi ? """


          \(Color16(.black).brighten().paint("// Fabric API", if: colors))
          modImplementation(\(stringColor.paint("\"\(aV.value.maven)\"", if: colors)))
      """ : "")
      }
      """)

      printed = true
    }

    if properties {
      let keyColor = Color16(.yellow)
      let stringColor = Color16(.red).brighten()

      if printed { print() }
      print("""
      \(Color16(.none).attr(.bold).paint("In gradle.properties (example mod):", if: colors))
      \(keyColor.paint("minecraft_version", if: colors))=\(stringColor.paint(mV!, if: colors))
      \(keyColor.paint("yarn_mappings", if: colors))=\(stringColor.paint(yV.value.version, if: colors))
      \(keyColor.paint("loader_version", if: colors))=\(stringColor.paint(lV.value.version, if: colors))\(!noApi ? """


      \(Color16(.black).brighten().paint("# Fabric API", if: colors))
      \(keyColor.paint("fabric_version", if: colors))=\(stringColor.paint(aV.value.version, if: colors))
      """ : "")
      """)

      printed = true
    }
  }
}

fileprivate func exitWithErrorStatus() {
  exit(1)
}

FabricVersions.main()
