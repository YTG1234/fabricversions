#include <iostream>

#include "MinecraftHelper.h"
#include "_internal.h"

using nlohmann::json;

static const std::string minecraft_manifest = "https://launchermeta.mojang.com/mc/game/version_manifest.json";

namespace mc {
    using namespace _internal;

    std::optional<std::string> getLatestVersion(bool verbose) {
        std::optional<std::string> result = get_url(minecraft_manifest, verbose);
        if (!result.has_value()) return result;
        else return std::optional(json::parse(result.value())["latest"]["release"]);
    }

    std::optional<json> getVersion(const std::string& version_number, bool verbose) {
        std::optional<std::string> urlResult = get_url(minecraft_manifest, verbose);

        if (!urlResult.has_value()) return urlResult;

        json j = json::parse(urlResult.value());

        if (!j["versions"].is_array()) {
            if (verbose) std::cerr << "versions is not an array!" << std::endl;
            return std::nullopt;
        }

        auto v = j["versions"].get<std::vector<json>>();
        for (json j2 : v) {
            if (j2["id"] == version_number) return j2;
        }
        
        return std::nullopt;
    }

}
