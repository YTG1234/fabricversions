# Fabric Versions
A simple command-line tool that can fetch the latest FabricMC versions for any given Minecraft version (as long as it exists and is supported by Fabric Meta).

## Download?!
Compiled binaries are not available quite yet, however the build process is very straightforward.

```shell
$ git clone https://github.com/YTG1234/fabricversions
$ cd fabricversions
$ ./configure
$ ./build
```
A compiled `fabricV` file should be created in a folder named `out`.

### Does This Work on Windows?
Honestly, I don't know. I don't have a Windows installation to test this on. If this tool is broken on Windows and you'd like to fix it, just PR!

## Usage
There are multiple command-line options available. They are: `m`, `p`, `b`, `l`, `v`, `c`, `P`, `B`, `L`, `V`, and `C`.  
The `m` option is the only one that receives a value - it is the Minecraft version. If the option is omitted, the tool will fetch the latest *release* version and use it.  

* `p`: Show a Fabric example mod `gradle.properties` snippet
    * Default: `false`
* `b`: Show a `build.gradle` (or `build.gradle.kts`, both work) snippet
    * Default: `false`
* `l`: Show a list of versions without any code snippets
    * Default: `true`
* `v`: Verbose output. It's a WIP.
    * Default: `false`
* `c`: Enable colors!
    * Default: `false`

As you might have guessed, the capital letter versions of these options just do the opposite! For instance, if you'd like to see the `build.gradle` but not the list, the options you will provide are `-Lb(m<minecraft version>)`.

## Libraries This Uses
* [cURLpp](https://github.com/jpbarrette/curlpp/tree/master)
* [json](https://github.com/nlohmann/json/tree/develop)
* [libcolors](https://github.com/YTG1234/libcolors/tree/main)
* [RapidXML](http://rapidxml.sourceforge.net/)
