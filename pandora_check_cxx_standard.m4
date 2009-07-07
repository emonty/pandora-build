AC_DEFUN([PANDORA_CHECK_CXX_STANDARD],[
  AC_REQUIRE([AC_CXX_COMPILE_STDCXX_0X])
  AS_IF([test "$GCC" = "yes"],
        [AS_IF([test "$ac_cv_cxx_compile_cxx0x_native" = "yes"],[],
               [AS_IF([test "$ac_cv_cxx_compile_cxx0x_gxx" = "yes"],
                      [CXXFLAGS="-std=gnu++0x ${CXXFLAGS}"],
                      [CXXFLAGS="-std=gnu++98"])
               ])
        ])
  AC_CXX_HEADER_STDCXX_98
])
