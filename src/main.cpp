#include <iostream>

#include <string>
#include <sstream>

#include <getopt.h>

#include <curlpp/cURLpp.hpp>

#include "ArgumentStructure.h"
#include "MinecraftHelper.h"
#include "FabricHelper.h"

#define PRINT(x) std::cout << x << std::endl;
#define DO_IF(x, y, z) if (x && y) { z; }

static curlpp::Cleanup cleanup;

ArgumentStructure getArgStructure(int agrc, char** argv);

int main(int argc, char** argv) {
    ArgumentStructure strt = getArgStructure(argc, argv);

    if (strt.isEmpty()) {
        std::cerr << "Unable to parse options" << std::endl;
        return EXIT_FAILURE;
    }

    DO_IF(strt.verbose, 1, PRINT("Verbose: " << strt.verbose))  
    DO_IF(strt.verbose, !strt.mc_version.empty(), PRINT("Minecraft Version: " << strt.mc_version))
    DO_IF(strt.verbose, 1, PRINT("gradle.properties: " << strt.gradle_properties << std::endl << "build.gradle: " << strt.build_gradle << std::endl << "Show Version List: " << strt.show_list))

    if (strt.mc_version.empty()) {
        std::optional<std::string> version = mc::getLatestVersion(strt.verbose);
        if (version.has_value()) strt.mc_version = version.value();
        else return EXIT_FAILURE;

        DO_IF(strt.verbose, 1, PRINT("Minecraft version was not specified, using latest version " << strt.mc_version));
    }

    PRINT("Loader: " << fabric::loader_ver_for_mc(strt.mc_version, strt.verbose).value().version_number);
    PRINT("Yarn: " << fabric::yarn_ver_for_mc(strt.mc_version, strt.verbose).value().version_number);
    PRINT("API: " << fabric::api_ver_for_mc(strt.mc_version, strt.verbose).value().version_number);

    return EXIT_SUCCESS;
}

ArgumentStructure getArgStructure(int argc, char** argv) {
    std::string mc_version;
    bool gradle_properties = false;
    bool build_gradle = false;
    bool show_list = true;
    bool verbose = false;

    {
        int c;
        while ((c = getopt(argc, argv, "m:pblvPBLV")) != EOF) {
            switch (c) {
                case 'm':
                    mc_version = optarg;
                    break;
                case 'p':
                    gradle_properties = true;
                    break;
                case 'b':
                    build_gradle = true;
                    break;
                case 'l':
                    show_list = true;
                    break;
                case 'P':
                    gradle_properties = false;
                    break;
                case 'B':
                    build_gradle = false;
                    break;
                case 'L':
                    show_list = false;
                    break;
                case 'v':
                    verbose = true;
                    break;
                case 'V':
                    verbose = false;
                    break;
                default:
                    return ArgumentStructure::EMPTY;
            }
        }
    }
    
    return ArgumentStructure(mc_version, build_gradle, gradle_properties, show_list, verbose);
}
