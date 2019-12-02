#include <string>
#include <vector>
#include <nvrtc.h>
#include <jitify.hpp>

#include "types.hpp.jit"
#include "timestamps.hpp.jit"
#include "operation.h.jit"
#include "traits.h.jit"

const char* kernel =
R"***(
// #include <cstdint>
// #include <type_traits>

#include <cudf/types.hpp>
#include <simt/limits>
#include <cudf/wrappers/timestamps.hpp>

// problematic
// #include "operation.h"
template<int N, typename T>
__global__ void kernel(T* data) {}
)***";

int main(void) {

  const std::vector<std::string> headers{
    cudf_types_hpp,
    cudf_wrappers_timestamps_hpp,
    operation_h,
    traits_h
  };

  static jitify::JitCache kernel_cache;
  jitify::Program program = kernel_cache.program(kernel, headers, {
    "-std=c++14",
    "-D__CUDACC_RTC__",
    "-D__CHAR_BIT__=" + std::to_string(__CHAR_BIT__),
    // define libcudacxx jitify guards
    "-D_LIBCUDACXX_HAS_NO_CTIME",
    "-D_LIBCUDACXX_HAS_NO_WCHAR",
    "-D_LIBCUDACXX_HAS_NO_CFLOAT",
    "-D_LIBCUDACXX_HAS_NO_STDINT",
    "-D_LIBCUDACXX_HAS_NO_CSTDDEF",
    "-D_LIBCUDACXX_HAS_NO_CLIMITS",
    "-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS",
    "-I/home/ptaylor/dev/rapids/jitify-libcu++-test/thirdparty/libcudacxx/include",
  });

}
