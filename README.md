# Fabric Versions
A simple command-line tool that can fetch the latest FabricMC versions for any given Minecraft version (as long as it exists and is supported by Fabric Meta).

## Download?!
Compiled binaries are not available quite yet, however the build process is very straightforward.

```shell
$ git clone https://github.com/YTG1234/fabricversions
$ cd fabricversions
$ ./scripts/configure
```
In order to build without installing, run `./scripts/build`. A compiled `fabricV` binary will be created in the `out` directory.  
In order to install the program, run `./scripts/instal` **as root**. A compiled binary will be created and installed in `/usr/local/bin`.
curlpp will also be built and installed.
Additionally, a manual page (`fabricV(1)`) will be installed in `/usr/local/man/man1`.

### Does This Work on Linux?
Honestly, I don't know. It works on my machine, but it may not work on yours.

### Does This Work on macOS?
Honestly, I don't know. I will try it soon and put the results here.

### Does This Work on Windows?
Probably not.

## Usage
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

## Libraries This Uses
* [cURLpp](https://github.com/jpbarrette/curlpp/tree/master)
* [json](https://github.com/nlohmann/json/tree/develop)
* [libcolors](https://github.com/YTG1234/libcolors/tree/main)
* [RapidXML](http://rapidxml.sourceforge.net/)

## Will This be Ported to Rust?
Yes, eventually.
