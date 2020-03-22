
## CMake

* Simple `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.0)

# set project name and version
project(<project_name> VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# find a package with version, `<PackageName>_FOUND` indicates if the package found
# Note: 2.0 could match 2.x, use `EXACT` to find the package in the exact version
# Use `REQUIRED` to show error if package not found, use `QUIET` to ignore
find_package(PackageName 2.0 REQUIRED)
if(NOT PackageName_FOUND)
  message(FATAL_ERROR "PackageName not found")
endif()

# specify place to store the `.so` library of our project
# output library name: `lib<project_name>.so`
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

# add library: add our own code so that the executable could use when they are compiled
add_library(${PROJECT_NAME} SHARED
src/abc/def.cc
...
)

# link libraries needed to build the project
target_link_libraries(${PROJECT_NAME}
${lib1_LIBS}
${lib2_LIBRARIES}
${PROJECT_SOURCE_DIR}/Thirdparty/<LibraryName>/lib/lib<LibraryName>.so
)

```
