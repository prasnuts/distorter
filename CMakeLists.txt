cmake_minimum_required(VERSION 3.12)

SET(PROJECT_NAME distortion)

PROJECT(${PROJECT_NAME} LANGUAGES CXX VERSION 0.0.1)

SET(CMAKE_CXX_STANDARD 11)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_AUTOUIC ON)
SET(CMAKE_AUTORCC ON)
SET(QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "The path to find the different qml modules" FORCE)

find_package(Qt5 5.12 COMPONENTS Core Widgets Multimedia Qml Quick Xml REQUIRED)

SET(SOURCES main.cpp util/ImageProvider.cpp util/Distorter.cpp)

SET(HEADERS util/ImageProvider.hpp util/Distorter.hpp)

SET(RESOURCES ui/qml.qrc)

SET(DATA_DIR -DDATA_DIR="${CMAKE_CURRENT_SOURCE_DIR}/data")
MESSAGE(STATUS "Data directory = ${DATA_DIR}")

FIND_PACKAGE(OpenCV 3.0 REQUIRED COMPONENTS opencv_core opencv_imgproc opencv_imgcodecs opencv_highgui opencv_video
        opencv_videoio opencv_calib3d opencv_aruco)

MESSAGE(STATUS "OpenCV found, version ${OpenCV_VERSION}")

ADD_EXECUTABLE(${PROJECT_NAME} ${SOURCES} ${HEADERS} ${RESOURCES})

TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME} PUBLIC ${OpenCV_INCLUDE_DIRS})

TARGET_LINK_LIBRARIES(${PROJECT_NAME} PUBLIC ${OpenCV_LIBS} Qt5::Core Qt5::Widgets Qt5::Multimedia Qt5::Qml Qt5::Quick
        Qt5::Xml)

TARGET_COMPILE_DEFINITIONS(${PROJECT_NAME} PRIVATE ${DATA_DIR})

