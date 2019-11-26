#include <string>
#include <vector>
#include <nvrtc.h>
#include <jitify.hpp>

// #include "types.h.jit"
#include "types.hpp.jit"
#include "timestamps.hpp.jit"

const char* kernel =
R"***(
#define _LIBCUDACXX_USE_CXX20_CHRONO
#define _LIBCUDACXX_USE_CXX17_TYPE_TRAITS
#include <simt/chrono>
#include <cudf/types.hpp>
#include <cudf/wrappers/timestamps.hpp>
template<int N, typename T>
__global__ void kernel(T* data) {}
)***";

int main(void) {

  const std::vector<std::string> headers{cudf_types_hpp, cudf_wrappers_timestamps_hpp};

  static jitify::JitCache kernel_cache;
  jitify::Program program = kernel_cache.program(kernel, headers, {
    "-std=c++14",
    // define libcudacxx jitify guards
    "-D_LIBCUDACXX_HAS_NO_CTIME",
    "-D_LIBCUDACXX_HAS_NO_WCHAR",
    "-D_LIBCUDACXX_HAS_NO_CFLOAT",
    "-D_LIBCUDACXX_HAS_NO_STDINT",
    "-D_LIBCUDACXX_HAS_NO_CSTDDEF",
    "-D_LIBCUDACXX_HAS_NO_CLIMITS",
    "-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS",
    // "-I/usr/include/linux",
    "-I/home/ptaylor/dev/rapids/jitify-libcu++-test/thirdparty/libcudacxx/include",
    "-I/home/ptaylor/dev/rapids/jitify-libcu++-test/thirdparty/libcudacxx/libcxx/include"
  });

}
