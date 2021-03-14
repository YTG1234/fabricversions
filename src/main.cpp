#include <iostream>
#include <string>
#include <getopt.h>

#define PRINT(x) std::cout << x << std::endl;

int main(int argc, char** argv) {
    std::string mc_version;
    bool gradle_properties = false;
    bool build_gradle = false;
    bool show_list = true;

    {
        int c;
        while ((c = getopt(argc, argv, "m:pblPBL")) != EOF) {
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
                default:
                    return EXIT_FAILURE;
            }
        }
    }

    if (mc_version.empty()) {
        
    }

    PRINT("something print");

    return EXIT_SUCCESS;
}
