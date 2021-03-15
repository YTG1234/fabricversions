#ifndef _COMMAND_LINE_HELPER_H
#define _COMMAND_LINE_HELPER_H

#include <string>

#include "ArgumentStructure.h"

namespace cmdline {
    ArgumentStructure get_arguments(const int argc, char** argv);
}

#endif /* _COMMAND_LINE_HELPER_H */
