# fabricversions(1) - fetch FabricMC versions

FABRICVERSIONS, 2021-04-10

```
fabricversions [-p] [--properties] [-b] [--buildscript] [-m version] [--minecraft-version version] [-l] [--list] [-v] [--verbose] [-c] [--colors] [--no-properties] [--no-buildscript] [--no-list] [--no-verbose] [--no-colors] [--no-api] [-h] [--help]
```


<a name="description"></a>

# Description

**fabricversions**
fetches Fabric Loader, Fabric API, and Yarn versions for a specified Minecraft version.


<a name="options"></a>

# Options



* **-p**, **--properties/--no-properties**  
  output an example mod gradle.properties snippet
  
* **-b**, **--buildscript/--no-buildscript**  
  output a Gradle buildscript snippet
  
* **-m**, **--minecraft-verion** **version**  
  select the Minecraft version
  
* **-l**, **--list/--no-list**  
  output a plain list of version numbers
  
* **-v**, **--verbose/--no-verbose**  
  verbose output
  
* **-c**, **--colors/--no-colors**  
  ANSI-colored output
  
* **--no-api**  
  don't show the Fabric API version. This option is here because this takes the longest to fetch
  
* **-h**, **--help**  
  show help information
  
  
  By default, **fabricversions** fetches the latest Minecraft version and shows a plain, uncolored list of version numbers (no verbose).
  

<a name="examples"></a>

# Examples


* fabricversions -cvm 1.16.2  
  Enable verbose output, enable colored output and output a list of FabricMC versions for Minecraft 1.16.2.
  
* fabricversions -cpb  
  Output a version list, Gradle buildscript and a gradle.properties snippet for the latest Minecraft version, all colored.
  
* fabricversions --no-list -pm 20w45a  
  Output a gradle.properties snippet for Minecraft 20w45a.
  

<a name="author"></a>

# Author

YTG123 &lt;[54103478+YTG1234@users.noreply](mailto:54103478+YTG1234@users.noreply).github.com&gt;


<a name="reporting-bugs"></a>

# Reporting Bugs

You can report bugs at GitHub: &lt;https://github.com/YTG1234/fabricversions/issues&gt;
