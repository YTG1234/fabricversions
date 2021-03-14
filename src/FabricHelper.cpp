#include <string>

#include <curlpp/cURLpp.hpp>
#include <curlpp/Options.hpp>

#include <nlohmann/json.hpp>

#include <rapidxml.hpp>

#include "FabricHelper.h"
#include "MinecraftHelper.h"
#include "_internal.h"

using nlohmann::json;

static const std::string fabric_meta_host = "https://meta.fabricmc.net/v2";
static const std::string fabric_api_metadata = "https://maven.fabricmc.net/net/fabricmc/fabric-api/fabric-api/maven-metadata.xml";

namespace fabric {
    MavenStringPair::MavenStringPair(std::string maven_coords, std::string version_number)
        : maven_coords(maven_coords), version_number(version_number) {}


    std::optional<MavenStringPair> loader_ver_for_mc(const std::string& mc_ver, bool verbose) {
        std::optional<std::string> res = get_url(fabric_meta_host + "/versions/loader/" + mc_ver + "?limit=1", verbose);
        if (!res.has_value()) return std::nullopt;

        json j = json::parse(res.value());
        return MavenStringPair(j[0]["loader"]["maven"], j[0]["loader"]["version"]);
    }
    
    std::optional<MavenStringPair> yarn_ver_for_mc(const std::string& mc_ver, bool verbose) {
        std::optional<std::string> res = get_url(fabric_meta_host + "/versions/yarn/" + mc_ver + "?limit=1", verbose);
        if (!res.has_value()) return std::nullopt;

        json j = json::parse(res.value());
        return MavenStringPair(j[0]["maven"], j[0]["version"]);
    }
    
    std::optional<MavenStringPair> api_ver_for_mc(const std::string& mc_ver, bool verbose) {
        std::optional<std::string> res;
        {
            std::optional<json> jO = mc::getVersion(mc_ver, verbose);
            if (!jO.has_value()) return std::nullopt;
            res = get_url(jO.value()["url"], verbose);
        }

        if (!res.has_value()) return std::nullopt;
        json j = json::parse(res.value());
        std::string assets = j["assets"];
        
        std::string latestVer;
        
        std::optional<std::string> api_res = get_url(fabric_api_metadata, verbose);
        if (!api_res.has_value()) return std::nullopt;
        std::string api_meta = api_res.value();

        {
            rapidxml::xml_document<> doc;
            doc.parse<0>(const_cast<char*>(api_meta.c_str()));
            auto node = doc.first_node("metadata")->first_node("versioning")->first_node("versions");

            rapidxml::xml_node<>* child;
            while ((child = node->first_node()) != 0) {
                std::string ver = child->value();
                if (ver.substr(ver.find("+") + 1, ver.length() - ver.find("+") - 1) == assets) latestVer = ver;
                node->remove_first_node();
            }
        }

        if (latestVer.empty()) return std::nullopt;
        return MavenStringPair("net.fabricmc.fabric-api:fabric-api:" + latestVer, latestVer);
    }
}
