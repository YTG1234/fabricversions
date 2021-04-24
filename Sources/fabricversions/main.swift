 import ArgumentParser

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
   }
 }

FabricVersions.main()
