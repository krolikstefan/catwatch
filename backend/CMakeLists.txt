cmake_minimum_required(VERSION 3.21)

project(KotekWatchBackend LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Network Sql)

qt_standard_project_setup()

qt_add_executable(kotekwatch-backend
    src/main.cpp
    src/ApiServer.cpp
    src/ApiServer.h
    src/Database.cpp
    src/Database.h
    src/SensorSimulator.cpp
    src/SensorSimulator.h
    src/models/Models.cpp
    src/models/Models.h
)

target_link_libraries(kotekwatch-backend PRIVATE
    Qt6::Core
    Qt6::Network
    Qt6::Sql
)

target_compile_definitions(kotekwatch-backend PRIVATE QT_QML_DEBUG)

set_target_properties(kotekwatch-backend PROPERTIES
    OUTPUT_NAME "kotekwatch-backend"
)
