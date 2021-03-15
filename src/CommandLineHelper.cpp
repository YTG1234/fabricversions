#include <getopt.h>
#include <curses.h>
#include <iostream>

#include "CommandLineHelper.h"
#include "_internal.h"

namespace cmdline {
    ArgumentStructure get_arguments(const int argc, char** argv) {
        std::string mc_version;
        bool gradle_properties = false;
        bool build_gradle = false;
        bool show_list = true;
        bool verbose = false;
        bool colors = false;

        {
            int c;
            while ((c = getopt(argc, argv, "m:pblvcPBLVC")) != EOF) {
                if (verbose) std::cout << internal::internal::comment << "Parsing option " << c << internal::internal::reset << std::endl;

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
                    case 'v':
                        verbose = true;
                        break;
                    case 'c':
                        colors = true;
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
                    case 'V':
                        verbose = false;
                        break;
                    case 'C':
                        colors = false;
                        break;
                    default:
                        return ArgumentStructure::EMPTY;
                }
            }

            internal::comment = colors ? !colors::Color(colors::Colors::black).brighten() : "";
            internal::reset = colors ? !colors::Color::RESET : "";

            if (verbose) {
                std::cout << internal::comment << "MC: " << mc_version << internal::reset << std::endl;
                std::cout << internal::comment << "gradle.properties: " << gradle_properties << internal::reset << std::endl;
                std::cout << internal::comment << "build.gradle: " << build_gradle << internal::reset << std::endl;
                std::cout << internal::comment << "List: " << show_list << internal::reset << std::endl;
                std::cout << internal::comment << "Verbose: " << verbose << internal::reset << std::endl;
                std::cout << internal::comment << "Colors: " << colors << internal::reset << std::endl;
            }
        }

        return ArgumentStructure(mc_version, build_gradle, gradle_properties, show_list, verbose, colors);
    }
}
