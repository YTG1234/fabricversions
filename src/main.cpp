#include <iostream>

#include <string>
#include <sstream>

#include <array>

#include <getopt.h>

#include <curlpp/cURLpp.hpp>

#include <Colors/Colors.h>

#include "ArgumentStructure.h"
#include "CommandLineHelper.h"
#include "MinecraftHelper.h"
#include "FabricHelper.h"

#define PRINT(x) std::cout << x << std::endl;
#define DO_IF(x, y, z) if (x && y) { z; }

using colors::Color;
using colors::Colors;

static curlpp::Cleanup cleanup;

int main(const int argc, char** argv) {
    ArgumentStructure strt = cmdline::get_arguments(argc, argv);

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

    auto loader_ver = fabric::loader_ver_for_mc(strt.mc_version, strt.verbose).value();
    auto yarn_ver = fabric::yarn_ver_for_mc(strt.mc_version, strt.verbose).value();
    auto api_ver = fabric::api_ver_for_mc(strt.mc_version, strt.verbose).value();

    auto colors = strt.color;
    auto red = colors ? !Color(Colors::red).brighten() : "";
    auto gold = colors ? !Color(Colors::yellow).darken() : "";
    auto reset = colors ? !Color::RESET : "";
    auto boldwhite = colors ? !Color(Colors::white).attr(colors::Attr::bold) : "";

    if (strt.show_list) {
        PRINT("Loader: " << loader_ver.version_number);
        PRINT("Yarn: " << yarn_ver.version_number);
        PRINT("API: " << api_ver.version_number << std::endl);
    } if (strt.build_gradle) {
        PRINT(boldwhite << "In your build.gradle:" << reset);

        PRINT("dependencies {" << std::endl
            << "\tminecraft(" << red << "\"com.mojang:minecraft:" << strt.mc_version << "\"" << reset << ")"
        );
        PRINT("\tmappings(" << red << "\"" << yarn_ver.maven_coords << "\"" << reset << ")");
        PRINT("\tmodImplementation(" << red << "\"" << loader_ver.maven_coords << "\"" << reset << ")" << std::endl);
        PRINT("\t" << (colors ? !Color(Colors::black).brighten() : "") << "// Fabric API" << reset);
        PRINT("\tmodImplementation(" << red << "\"" << api_ver.maven_coords << "\"" << reset << ")");
        PRINT("}" << std::endl);
    } if (strt.gradle_properties) {
        PRINT(boldwhite << "In gradle.properties (example mod):" << reset);

        PRINT(gold << "minecaft_version" << reset << "=" << red << strt.mc_version << reset);
        PRINT(gold << "yarn_mappings" << reset << "=" << red << yarn_ver.version_number << reset);
        PRINT(gold << "loader_version" << reset << "=" << red << loader_ver.version_number << reset << std::endl);
        PRINT((colors ? !Color(Colors::black).brighten() : "") << "# Fabric API" << reset);
        PRINT(gold << "fabric_version" << reset << "=" << red << api_ver.version_number << reset << std::endl);
    }

    return EXIT_SUCCESS;
}
