#include <string>
#include <vector>
#include <nvrtc.h>
#include <jitify.hpp>

// #include "timestamps.hpp"
#include "timestamps.hpp.jit"

const char* kernel =
R"***(
  #include <cudf/wrappers/timestamps.hpp>
  template<int N, typename T>
  __global__ void kernel(T* data) {
  }
)***";

int main(void) {

  const std::vector<std::string> headers{cudf_wrappers_timestamps_hpp};

  static jitify::JitCache kernel_cache;
  jitify::Program program = kernel_cache.program(kernel, headers, {
    "-std=c++14",
    "-D__x86_64__",
    "-D_LIBCPP_STD_VER=14",
    "-D_LIBCPP_HAS_NO_PRAGMA_PUSH_POP_MACRO",
    "-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS",
    "-I/usr/include",
    "-I/usr/include/c++/7",
    "-I/usr/include/c++/7/tr1",
    "-I/usr/include/x86_64-linux-gnu",
    "-I/usr/local/cuda-10.1/targets/x86_64-linux/include",
    "-I/home/ptaylor/dev/rapids/jitify-libcu++-test/thirdparty/libcudacxx/include",
    "-I/home/ptaylor/dev/rapids/jitify-libcu++-test/thirdparty/libcudacxx/libcxx/include"
  });

}
