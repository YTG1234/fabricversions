cmake_minimum_required (VERSION 3.19.6)
project (fabricV VERSION 1.0.0)

set (BUILD_SHARED_LIBS OFF)
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

if (${CMAKE_BUILD_TYPE} STREQUAL "release")
	set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
endif()

set (source_dir "${PROJECT_SOURCE_DIR}/src")
set (lib_dir "${PROJECT_SOURCE_DIR}/lib")
file (GLOB source_files "${source_dir}/*.cpp")

add_executable (${PROJECT_NAME} ${source_files})

set_property (TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 17)

set (JSON_BuildTests OFF CACHE INTERNAL "")
add_subdirectory ("${lib_dir}/json")
target_link_libraries (${PROJECT_NAME} nlohmann_json::nlohmann_json)

set (CURLPP_BUILD_SHARED_LIBS OFF)
add_subdirectory ("${lib_dir}/curlpp")
target_link_libraries (${PROJECT_NAME} curlpp_static)
target_include_directories (${PROJECT_NAME} PRIVATE "${lib_dir}/curlpp/include")

target_include_directories (${PROJECT_NAME} PRIVATE "${lib_dir}/rapidxml")

add_subdirectory ("${lib_dir}/libcolors")
target_link_libraries (${PROJECT_NAME} colors)
