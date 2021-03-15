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

using colors::Color;
using colors::Colors;

static curlpp::Cleanup cleanup;

int main(const int argc, char** argv) {
    ArgumentStructure strt = cmdline::get_arguments(argc, argv);

    if (strt.isEmpty()) {
        std::cerr << "Unable to parse options" << std::endl;
        return EXIT_FAILURE;
    }

    // TODO Verbose output

    if (strt.mc_version.empty()) {
        std::optional<std::string> version = mc::getLatestVersion(strt.verbose);
        if (version.has_value()) strt.mc_version = version.value();
        else return EXIT_FAILURE;
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
        std::cout << "Loader: " << loader_ver.version_number << std::endl;
        std::cout << "Yarn: " << yarn_ver.version_number << std::endl;
        std::cout << "API: " << api_ver.version_number << std::endl << std::endl;
    } if (strt.build_gradle) {
        std::cout << boldwhite << "In your build.gradle:" << reset << std::endl;

        std::cout
            << "dependencies {" << std::endl
            << "\tminecraft(" << red
            << "\"com.mojang:minecraft:" << strt.mc_version
            << "\"" << reset << ")"
            << std::endl;
        std::cout << "\tmappings(" << red << "\"" << yarn_ver.maven_coords << "\"" << reset << ")" << std::endl;
        std::cout << "\tmodImplementation(" << red << "\"" << loader_ver.maven_coords << "\"" << reset << ")" << std::endl << std::endl;
        std::cout << "\t" << (colors ? !Color(Colors::black).brighten() : "") << "// Fabric API" << reset << std::endl;
        std::cout << "\tmodImplementation(" << red << "\"" << api_ver.maven_coords << "\"" << reset << ")" << std::endl;
        std::cout << "}" << std::endl << std::endl;
    } if (strt.gradle_properties) {
        std::cout << boldwhite << "In gradle.properties (example mod):" << reset << std::endl;

        std::cout << gold << "minecaft_version" << reset << "=" << red << strt.mc_version << reset << std::endl;
        std::cout << gold << "yarn_mappings" << reset << "=" << red << yarn_ver.version_number << reset << std::endl;
        std::cout << gold << "loader_version" << reset << "=" << red << loader_ver.version_number << reset << std::endl << std::endl;
        std::cout << (colors ? !Color(Colors::black).brighten() : "") << "# Fabric API" << reset << std::endl;
        std::cout << gold << "fabric_version" << reset << "=" << red << api_ver.version_number << reset << std::endl << std::endl;
    }

    return EXIT_SUCCESS;
}
