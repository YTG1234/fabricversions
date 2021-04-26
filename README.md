# Fabric Versions
A simple command-line tool that can fetch the latest FabricMC versions for any given Minecraft version (as long as it exists and is supported by Fabric Meta).

## Download?!
Compiled binaries are not available quite yet, ~~however the build process is very straightforward.~~

- Download and install the latest [Swift toolchain](https://swift.org/download) (Arch users: Use [swift-bin](https://aur.archlinux.org/packages/swift-bin)<sup>AUR</sup>. Ubuntu and RHEL based users: Download from the official site).
- Run the following commands
```shell
$ git clone https://github.com/YTG1234/fabricversions
$ cd fabricversions
$ swift build -c release
```
- A compiled `fabricversions` binary will be created in the `.build/release` directory.

### Does This Work on Linux?
Honestly, I don't know. It works on my machine, but it may not work on yours.

### Does This Work on macOS?
I don't know. I will test soon and update here.

### Does This Work on Windows?
I don't know.

## Usage

### Synopsis

```
fabricversions [-p] [--properties] [-b] [--buildscript] [-m version] [--minecraft-version __version__] [-l] [--list] [-v] [--verbose] [-c] [--colors] [--no-properties] [--no-buildscript] [--no-list] [--no-verbose] [--no-colors] [--no-api] [-h] [--help]
```


<a name="options"></a>

### Options

* **-p**, **--properties** / **--no-properties**  
  output an example mod gradle.properties snippet
  
* **-b**, **--buildscript** / **--no-buildscript**  
  output a Gradle buildscript snippet
  
* **-m**, **--minecraft-version** <ins>version</ins>  
  select the Minecraft version
  
* **-l**, **--list** / **--no-list**  
  output a plain list of version numbers
  
* **-v**, **--verbose** / **--no-verbose**  
  verbose output
  
* **-c**, **--colors** / **--no-colors**  
  ANSI-colored output
  
* **--no-api**  
  don't show the Fabric API version. This option is here because this takes the longest to fetch
  
* **-h**, **--help**  
  show help information

By default, **fabricversions** fetches the latest Minecraft version and shows a plain, uncolored list of version numbers (no verbose).
  
<a name="examples"></a>

### Examples

- `fabricversions -cvm 1.16.2`  
Enable verbose output, enable colored output and output a list of FabricMC versions for Minecraft 1.16.2.
  
- `fabricversions -cpb`  
Output a version list, Gradle buildscript and a gradle.properties snippet for the latest Minecraft version, all colored.
  
- `fabricversions --no-list -pm 20w45a`  
Output a gradle.properties snippet for Minecraft 20w45a.

## Libraries This Uses
- [Argument Parser](https://github.com/apple/swift-argument-parser)
- [SwiftyXMLParser](https://github.com/yahoojapan/SwiftyXMLParser)

