# Fabric Versions
A simple command-line tool that can fetch the latest FabricMC versions for any given Minecraft version (as long as it exists and is supported by Fabric Meta).

## Download?!
Compiled binaries are not available quite yet~~, however the build process is very straightforward.~~

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
Yes.

### Does This Work on Windows?
Probably not.

## Usage
<details>
<summary>Old Usage</summary>

There are multiple command-line options available. They are: `m`, `p`, `b`, `l`, `v`, `c`, `P`, `B`, `L`, `V`, and `C`.  
The `m` option is the only one that receives a value - it is the Minecraft version. If the option is omitted, the tool will fetch the latest *release* version and use it.  

* `p`: Show a Fabric example mod `gradle.properties` snippet
    * Default: `false`
* `b`: Show a `build.gradle` (or `build.gradle.kts`, both work) snippet
    * Default: `false`
* `l`: Show a list of versions without any code snippets
    * Default: `true`
* `v`: Verbose output.
    * Default: `false`
* `c`: Enable colors!
    * Default: `false`

As you might have guessed, the capital letter versions of these options just do the opposite! For instance, if you'd like to see the `build.gradle` but not the list, the options you will provide are `-Lb(m<minecraft version>)`.

</details>
