#ifndef _ARGUMENT_STRUCTURE_H
#define _ARGUMENT_STRUCTURE_H

#include <string>

struct ArgumentStructure {
    std::string mc_version;
    bool build_gradle, gradle_properties, show_list, verbose, color;
    
    ArgumentStructure();
    ArgumentStructure(std::string mc_version, bool build_gradle, bool gradle_properties, bool show_list, bool verbose, bool color);
    
    bool isEmpty();
    
    static ArgumentStructure EMPTY;
};

#endif /* _ARGUMENT_STRUCTURE_H */
