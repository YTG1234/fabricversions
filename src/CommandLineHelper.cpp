#include <getopt.h>
#include <curses.h>

#include "CommandLineHelper.h"

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
        }

        return ArgumentStructure(mc_version, build_gradle, gradle_properties, show_list, verbose, colors);
    }
}
