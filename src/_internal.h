#ifndef _UNDERSCORE_INTERNAL_H
#define _UNDERSCORE_INTERNAL_H

#include <string>
#include <optional>

namespace _internal {
    std::optional<std::string> get_url(std::string url, bool verbose);
}

using namespace _internal;

#endif /* _UNDERSCORE_INTERNAL_H */
