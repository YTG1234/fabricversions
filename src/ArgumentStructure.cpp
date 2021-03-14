#include "ArgumentStructure.h"

ArgumentStructure::ArgumentStructure()
    : mc_version(""), build_gradle(false), gradle_properties(false), show_list(false), verbose(false)
{}

ArgumentStructure::ArgumentStructure(std::string mc_version, bool build_gradle, bool gradle_properties, bool show_list, bool verbose)
    : mc_version(mc_version), build_gradle(build_gradle), gradle_properties(gradle_properties), show_list(show_list), verbose(verbose)
{}

bool ArgumentStructure::isEmpty() {
    return this->mc_version == "" && !this->build_gradle && !this->gradle_properties && !this->show_list && !this->verbose;
}

ArgumentStructure ArgumentStructure::EMPTY = ArgumentStructure();
