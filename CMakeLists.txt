cmake_minimum_required(VERSION 3.16)
project(HorizonOverlayWin LANGUAGES Swift)

find_package(SwiftWin32 REQUIRED CONFIG)

add_executable(QuickCaptureApp
    "Constella Horizon/Windows/QuickCaptureWindowWin.swift"
)

# Required due to SR-12683 when using @main
# This ensures the app is built correctly on Windows
# See SwiftWin32 documentation for details
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  target_compile_options(QuickCaptureApp PRIVATE -parse-as-library)
endif()

target_link_libraries(QuickCaptureApp PRIVATE SwiftWin32)
