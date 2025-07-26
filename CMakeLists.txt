cmake_minimum_required(VERSION 3.16)

project(BrickCreator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_PREFIX_PATH "~/Qt/6.9.1/gcc_64/lib/cmake")

find_package(Qt6 REQUIRED COMPONENTS Quick Core Svg Qml Gui Concurrent)

include(Utility.cmake)

qt_standard_project_setup(REQUIRES 6.8)

set(target appBrickCreator)

set(CMAKE_C_PLATFORM_LINKER_ID LLD)
set(CMAKE_C_LINK_LIBRARIES_PROCESSING ORDER=REVERSE DEDUPLICATION=ALL)
set(CMAKE_CXX_PLATFORM_LINKER_ID LLD)
set(CMAKE_CXX_LINK_LIBRARIES_PROCESSING ORDER=REVERSE DEDUPLICATION=ALL)
set(QT_FORCE_CMP0156_TO_VALUE NEW)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

# Enable -Wall, -Werror, -Wswitch-enum
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Wall -Werror -Wextra -Wswitch-enum)
endif()

set(ENV{QTFRAMEWORK_BYPASS_LICENSE_CHECK} 1)
set(QML_IMPORT_PATH "${CMAKE_BINARY_DIR}" CACHE STRING "extra qml import paths")

qt_add_executable(${target} main.cpp)

add_subdirectory(app)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${target} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBrickCreator
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${target}
    PRIVATE Qt6::Quick appModule
)

include(GNUInstallDirs)
install(TARGETS ${target}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
