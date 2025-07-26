macro(add_module target module)
        file(GLOB qml_files qml/*.qml)
        file(GLOB_RECURSE resources resources/*)
        file(GLOB_RECURSE include *.h)
        file(GLOB src src/*.cpp)

        foreach(file ${qml_files} ${src})
            get_filename_component(file_name ${file} NAME)
            set_source_files_properties(${file} PROPERTIES QT_RESOURCE_ALIAS "${file_name}")
        endforeach()

        foreach (file ${resources} ${include})
            file(RELATIVE_PATH relative_file ${CMAKE_CURRENT_SOURCE_DIR} ${file})
            set_source_files_properties(${file} PROPERTIES QT_RESOURCE_ALIAS "${relative_file}")
        endforeach()

        qt_add_qml_module(${module} STATIC
          URI ${target}
          VERSION 1.0
          RESOURCE_PREFIX /
          QML_FILES ${qml_files}
          RESOURCES ${resources}
          SOURCES ${include} ${src}
        )

        foreach(file ${include})
          get_filename_component(path ${file} DIRECTORY)
          target_include_directories(${module} PRIVATE ${path})
          message(STATUS "Include path: ${path}")
        endforeach()
        target_include_directories(${module} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
        message(STATUS "Include path: ${CMAKE_CURRENT_SOURCE_DIR}")
  endmacro()
