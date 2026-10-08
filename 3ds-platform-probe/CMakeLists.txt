cmake_minimum_required(VERSION 3.24)
project(fheroes2_platform_probe VERSION 0.1.0 LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
if(NOT NINTENDO_3DS)
    message(FATAL_ERROR "Use the 3DS toolchain file for this target")
endif()
set(SDL_SHARED OFF CACHE BOOL "" FORCE)
set(SDL_STATIC ON CACHE BOOL "" FORCE)
set(SDL_TEST OFF CACHE BOOL "" FORCE)
set(SDL_TESTS OFF CACHE BOOL "" FORCE)
set(SDL_INSTALL OFF CACHE BOOL "" FORCE)
set(SDL_SENSOR OFF CACHE BOOL "" FORCE)
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../vendor/SDL2" "sdl2")
add_executable(fheroes2-probe source/main.cpp)
target_compile_options(fheroes2-probe PRIVATE -Wall -Wextra -Wpedantic -fsigned-char)
target_link_libraries(fheroes2-probe PRIVATE SDL2::SDL2main SDL2::SDL2-static)
target_compile_definitions(fheroes2-probe PRIVATE PROBE_VERSION="${PROJECT_VERSION}")
find_program(THREEDSXTOOL 3dsxtool HINTS "${PROBE_SDK}/tools/bin" REQUIRED)
find_program(SMDHTOOL smdhtool HINTS "${PROBE_SDK}/tools/bin" REQUIRED)
add_custom_command(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.smdh"
    COMMAND "${SMDHTOOL}" --create "fheroes2 platform probe" "3DS screens, input, SD and runtime" "Heroes 2 3DS project"
        "${PROBE_SDK}/libctru/default_icon.png" "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.smdh"
    DEPENDS "${PROBE_SDK}/libctru/default_icon.png" VERBATIM)
add_custom_command(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.3dsx"
    COMMAND "${THREEDSXTOOL}" "$<TARGET_FILE:fheroes2-probe>" "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.3dsx"
        "--smdh=${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.smdh"
    DEPENDS fheroes2-probe "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.smdh" VERBATIM)
add_custom_target(probe_3dsx ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/fheroes2-probe.3dsx")
