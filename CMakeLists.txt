cmake_minimum_required(VERSION 3.16)

project(vehicleDashboardQML VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Mqtt)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appvehicleDashboardQML
    main.cpp
)

qt_add_qml_module(appvehicleDashboardQML
    URI vehicleDashboardQML
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Speedometer.qml
        QML_FILES FuelGauge.qml
        QML_FILES DigitalClock.qml
        QML_FILES TurnIndicators.qml
        QML_FILES DashboardShape.qml
        QML_FILES TotalKm.qml
        QML_FILES StartAndStop.qml
        SOURCES
        SOURCES mqtt.h mqtt.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appvehicleDashboardQML PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appvehicleDashboardQML
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appvehicleDashboardQML
    PRIVATE Qt6::Quick Qt6::Mqtt
)

include(GNUInstallDirs)
install(TARGETS appvehicleDashboardQML
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
