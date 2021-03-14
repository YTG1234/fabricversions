#ifndef _FABRIC_HELPER_H
#define _FABRIC_HELPER_H

#include <string>

namespace fabric {
    struct MavenStringPair {
        std::string maven_coords;
        std::string version_number;
        
        MavenStringPair(std::string maven_coords, std::string version_number);
    };
    
    std::optional<MavenStringPair> loader_ver_for_mc(const std::string& mc_ver, bool verbose);
    std::optional<MavenStringPair> yarn_ver_for_mc(const std::string& mc_ver, bool verbose);
    std::optional<MavenStringPair> api_ver_for_mc(const std::string& mc_ver, bool verbose);
}

#endif /* _FABRIC_HELPER_H */
