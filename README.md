# FabricVersions
A simple command line tool that can fetch the latest FabricMC versions for any given Minecraft version (as long as it exists and supported by Fabric Meta).

## Contributing
All contributions are welcome! Your contributions will be licensed under GPL-3.0-or-later (see [COPYING](COPYING)).  
When creating new source files, paste the license notice (found at [NOTICE](NOTICE)) at the top of the file,
enclosed in a block comment and keeping indentation.  
When doing this, make sure to replace `YTG123` with your name. If you are changing an existing file, add your name after the existing name(s).

## Download
### Arch Linux
Download the latest release `.pkg.tar.zst` from the releases page and install it using `pacman -U`.  
Alternatively, import my PGP key and install `fabricversions` from the AUR (also requires installing `swift-bin` or `swift-language`):
```
# pacman-key -r 4B81184A270A28B5
# pacman-key --lsign-key 4B81184A270A28B5
```
You might also need to import the key manually, using `gpg`. Do that if you need to.

```
$ git clone https://aur.archlinux.org/swift-bin.git
$ cd swift-bin
$ makepkg -si
$ cd ..
$ git clone https://aur.archlinux.org/fabricversions.git
$ cd fabricversions
$ makepkg -si
```

If you want to remove uneeded dependencies afterwards, remove `swift-bin` and then remove all orphans `pacman -Qtdq | pacman -Rs -`.

### Debian
A `.deb` package is coming soon.

### RHEL/SUSE
A `.rpm` package is coming soon.

### Building From Source
- Download and install the latest Swift toolchain  
Arch users: Use [swift-bin](https://aur.archlinux.org/packages/swift-bin)<sup>AUR</sup>.  
Debian and RHEL based users: Download from the [official site](https://swift.org/download).  
macOS users: Install Xcode because for some reason the Swift package manager doesn't work without Xcode installed.  
Other operating systems: Figure it out.

- Run the following commands (requires a Make implementation such as GNU Make)
```shell
$ git clone https://github.com/YTG1234/fabricversions
$ cd fabricversions
$ make
```
- In case `make` produces an error, try running `make NOSTATIC=1`. You will then need to keep Swift installed to use the software.
- A compiled `fabricversions` binary will be created in the `.build/release` directory, as well as a compressed man page in the `man` directory.

- In order to install the tool, run
```shell
$ sudo make install
```
You can of course use `doas` or any other similar program.  
To uninstall, run the same command but replace `install` with `uninstall`.

- In order to use the tool, you will need to have curl and libxml2 installed.

### Does This Work on Linux?
Honestly, I don't know. It works on my machine, but it may not work on yours.

### Does This Work on macOS?
I don't know. I will test soon and update here.

### Does This Work on Windows?
I don't know.

## Usage

### Synopsis

```
fabricversions [-p] [--properties] [-b] [--buildscript] [-m version] [--minecraft-version version] [-l] [--list] [-v] [--verbose] [-c] [--colors] [--no-properties] [--no-buildscript] [--no-list] [--no-verbose] [--no-colors] [--no-api] [-h] [--help]
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

By default, **fabricversions** fetches the latest Minecraft version and shows a plain, uncoloured list of version numbers (no verbose).
  
<a name="examples"></a>

### Examples

- `fabricversions -cvm 1.16.2`  
Enable verbose output, enable coloured output and output a list of FabricMC versions for Minecraft 1.16.2.
  
- `fabricversions -cpb`  
Output a version list, Gradle buildscript and a gradle.properties snippet for the latest Minecraft version, all coloured.
  
- `fabricversions --no-list -pm 20w45a`  
Output a gradle.properties snippet for Minecraft 20w45a.

## Libraries This Uses
- [Argument Parser](https://github.com/apple/swift-argument-parser)
- [SwiftyXMLParser](https://github.com/yahoojapan/SwiftyXMLParser)

