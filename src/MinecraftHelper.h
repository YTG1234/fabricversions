#ifndef _MINECRAFT_HELPER_H
#define _MINECRAFT_HELPER_H

#include <string>
#include <optional>

#include <nlohmann/json.hpp>

namespace mc {
    std::optional<std::string> getLatestVersion(bool verbose);
    std::optional<nlohmann::json> getVersion(const std::string& versionNumber, bool verbose);
}

#endif /* _MINECRAFT_HELPER_H */
