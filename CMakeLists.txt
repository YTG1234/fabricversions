cmake_minimum_required (VERSION 3.19.6)
project (fabricV VERSION 1.0.0)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
set (source_dir "${PROJECT_SOURCE_DIR}/src/")
file (GLOB source_files "${source_dir}/*.cpp")

add_executable (${PROJECT_NAME} ${source_files})

set_property (TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)

find_package (nlohmann_json 3.2.0 REQUIRED)
target_link_libraries (${PROJECT_NAME} nlohmann_json::nlohmann_json)
