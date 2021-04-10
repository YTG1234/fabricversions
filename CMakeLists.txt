cmake_minimum_required(VERSION 3.19.6)
project(fabricV VERSION 1.0.0)

set(BUILD_SHARED_LIBS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

if (${CMAKE_BUILD_TYPE} STREQUAL "release")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
endif ()

set(source_dir "${PROJECT_SOURCE_DIR}/src")
set(lib_dir "${PROJECT_SOURCE_DIR}/lib")
file(GLOB source_files "${source_dir}/*.cpp")

add_executable(${PROJECT_NAME} ${source_files})

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 17)

# Deps
include(cmake/CPM.cmake)
CPMAddPackage(
	NAME "nlohmann_json"
	VERSION "3.9.1"
	OPTIONS "JSON_BuildTests Off CACHE INTERNAL"
	URL "https://github.com/nlohmann/json/releases/download/v3.9.1/include.zip"
)
CPMAddPackage(
	NAME "curlpp"
	OPTIONS "CURLPP_BUILD_SHARED_LIBS Off"
	GIT_REPOSITORY "https://github.com/jpbarrette/curlpp"
	GIT_TAG "a4da422a1d107779e02869c75d0ba45ae5e2758b"
)
CPMAddPackage(
	NAME "rapidxml"
	GIT_REPOSITORY "https://github.com/discord/rapidxml"
	GIT_TAG "master"
)
CPMAddPackage("gh:YTG1234/libcolors#main")

# Linking 'em
add_library(nlohmann_json INTERFACE IMPORTED)
target_include_directories(nlohmann_json INTERFACE ${nlohmann_json_SOURCE_DIR})

target_link_libraries(${PROJECT_NAME}
	nlohmann_json
	curlpp_static
	colors
	pthread
)
target_include_directories(${PROJECT_NAME} PRIVATE ${rapidxml_SOURCE_DIR} "${curlpp_SOURCE_DIR}/include" "${nlohmann_json_SOURCE_DIR}/single_include")

file(ARCHIVE_CREATE OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/fabricV.1.gz
	PATHS ${CMAKE_CURRENT_SOURCE_DIR}/man/fabricV.1
	FORMAT raw
	COMPRESSION GZip
	VERBOSE)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/fabricV.1.gz
	PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
	DESTINATION share/man/man1)

install(TARGETS ${PROJECT_NAME}
	PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
	RUNTIME DESTINATION bin)
