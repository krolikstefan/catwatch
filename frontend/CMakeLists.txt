cmake_minimum_required(VERSION 3.21)

project(KotekWatchFrontend LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Network Quick QuickControls2)

qt_standard_project_setup()

qt_add_executable(kotekwatch-frontend
    src/main.cpp
    src/ApiClient.cpp
    src/ApiClient.h
)

qt_add_qml_module(kotekwatch-frontend
    URI KotekWatch
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ActivityScreen.qml
        qml/WeatherScreen.qml
        qml/RelaxScreen.qml
)

target_link_libraries(kotekwatch-frontend PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Network
    Qt6::Quick
    Qt6::QuickControls2
)

target_compile_definitions(kotekwatch-frontend PRIVATE QT_QML_DEBUG)

set_target_properties(kotekwatch-frontend PROPERTIES
    OUTPUT_NAME "kotekwatch-frontend"
)
