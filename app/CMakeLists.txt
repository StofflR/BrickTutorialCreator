get_filename_component(target ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" target ${target})
set(module ${target}Module)

file(GLOB_RECURSE resources resources/*)

foreach(file ${resources})
    get_filename_component(file_name ${file} NAME)
    set_source_files_properties(${file} PROPERTIES QT_RESOURCE_ALIAS "${file_name}")
endforeach()

set_source_files_properties(qml/FontStyle.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/AppStyle.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

add_module(${target} ${module})

qt_add_resources(${module} "fonts"
    PREFIX "/app"
    FILES ${resources}
)

target_link_libraries(${module} PRIVATE 
Qt6::Quick
Qt6::Core 
Qt6::Svg 
Qt6::Gui
Qt6::Concurrent
Qt6::Widgets
)
