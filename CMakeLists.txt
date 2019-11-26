
cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project (node_cuda VERSION 0.0.1 LANGUAGES C CXX CUDA)

if(NOT CMAKE_CUDA_COMPILER)
  message(SEND_ERROR "CMake cannot locate a CUDA compiler")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/" ${CMAKE_MODULE_PATH})
include(FindCUDALibs)
include(FindCUDAWrapper)

###################################################################################################
# - compiler options ------------------------------------------------------------------------------

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --expt-extended-lambda --expt-relaxed-constexpr -Xcompiler=-fPIC")

add_definitions("-DJITIFY_PRINT_ALL=1")

###################################################################################################
# - include paths ---------------------------------------------------------------------------------


if(CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES)
    include_directories("${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}")
endif()

include_directories("${CMAKE_SOURCE_DIR}/thirdparty/jitify")
include_directories("${CMAKE_SOURCE_DIR}/thirdparty/libcudacxx/include")

###################################################################################################
# - library paths ---------------------------------------------------------------------------------

link_directories("${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES}" # CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES
                                                           # is an undocumented variable containing
                                                           # the link directories for nvcc
)

add_executable(main "${CMAKE_SOURCE_DIR}/main.cu")
target_link_libraries(main cuda cudart nvrtc)
