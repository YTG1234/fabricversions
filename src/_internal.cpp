#include <sstream>
#include <curlpp/cURLpp.hpp>
#include <curlpp/Options.hpp>
#include "_internal.h"

namespace _internal {
    std::optional<std::string> get_url(std::string url, bool verbose) {
        try {
            std::stringstream result;
            result << curlpp::options::Url(url);
            return std::optional(result.str());
        } catch (std::exception& e) {
            std::cerr << "Failed to fetch URL " << url << "." << (!verbose ? "Use -v for details." : "") << std::endl;
            if (verbose) std::cerr << e.what();
            return std::nullopt;
        }
    }
}
