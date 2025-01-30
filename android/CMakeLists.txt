cmake_minimum_required(VERSION 3.10)

project(live2d_bridge)

# Live2D SDK 경로 설정
set(SDK_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../..)
set(CORE_PATH ${SDK_ROOT_PATH}/Core)
set(FRAMEWORK_PATH ${SDK_ROOT_PATH}/Framework)
set(THIRD_PARTY_PATH ${SDK_ROOT_PATH}/Samples/OpenGL/thirdParty)
set(STB_PATH ${THIRD_PARTY_PATH}/stb)

# C++ 버전 설정
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Live2D Core 추가
add_library(Live2DCubismCore STATIC IMPORTED)
set_target_properties(Live2DCubismCore
  PROPERTIES
    IMPORTED_LOCATION
      ${CORE_PATH}/lib/android/${ANDROID_ABI}/libLive2DCubismCore.so
    INTERFACE_INCLUDE_DIRECTORIES ${CORE_PATH}/include
)

# Live2D Framework 추가
set(FRAMEWORK_SOURCE OpenGL)
add_subdirectory(${FRAMEWORK_PATH} ${CMAKE_CURRENT_BINARY_DIR}/Framework)
target_compile_definitions(Framework PUBLIC CSM_TARGET_ANDROID_ES2)

# Flutter FFI를 위한 네이티브 라이브러리 생성
add_library(live2d SHARED
    src/main/cpp/live2d_bridge.cpp
    src/main/cpp/live2d_renderer.cpp
)

# OpenGL 및 기타 라이브러리 찾기
find_library(log-lib log)

# 라이브러리 링크
target_link_libraries(live2d
    Framework
    Live2DCubismCore
    GLESv3  # GLESv2 대신 GLESv3 사용 (기존 코드 유지)
    ${log-lib}
)

# include 디렉토리 설정
include_directories(src/main/cpp/include)
target_include_directories(live2d PRIVATE ${STB_PATH})
