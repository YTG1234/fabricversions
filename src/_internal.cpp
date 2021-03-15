#include <sstream>
#include <curlpp/cURLpp.hpp>
#include <curlpp/Options.hpp>
#include "_internal.h"

namespace _internal {
    std::string internal::comment = "";
    std::string internal::reset = "";

    std::optional<std::string> get_url(std::string url, bool verbose) {
        if (verbose) std::cout << internal::comment << "Called get_url for " << url << internal::reset << std::endl;

        try {
            std::stringstream result;

            if (verbose) std::cout << internal::comment << "Fetching " << url << "..." << internal::reset << std::endl;
            result << curlpp::options::Url(url);

            return std::optional(result.str());
        } catch (std::exception& e) {
            std::cerr << "Failed to fetch URL " << url << "." << (!verbose ? "Use -v for details." : "") << std::endl;
            if (verbose) std::cerr << e.what();
            return std::nullopt;
        }
    }
}
