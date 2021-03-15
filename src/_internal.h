#ifndef _UNDERSCORE_INTERNAL_H
#define _UNDERSCORE_INTERNAL_H

#include <string>
#include <optional>
#include <Colors/Colors.h>

namespace _internal {
    std::optional<std::string> get_url(std::string url, bool verbose);

    class internal {
    public:
        static std::string comment;
        static std::string reset;
    };
}

using namespace _internal;

#endif /* _UNDERSCORE_INTERNAL_H */
