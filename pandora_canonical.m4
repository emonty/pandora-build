dnl The standard setup for how we build Pandora projects

AC_DEFUN([PANDORA_CANONICAL_TARGET],[

  AC_REQUIRE([AC_PROG_CC])
  # We need to prevent canonical target
  # from injecting -O2 into CFLAGS - but we won't modify anything if we have
  # set CFLAGS on the command line, since that should take ultimate precedence
  AS_IF([test "x${ac_cv_env_CFLAGS_set}" = "x"],
        [CFLAGS=""])
  AS_IF([test "x${ac_cv_env_CXXFLAGS_set}" = "x"],
        [CXXFLAGS=""])
  
  AC_CANONICAL_TARGET
  
  AM_INIT_AUTOMAKE(-Wall -Werror nostdinc subdir-objects)
  
  dnl Force dependency tracking on for Sun Studio builds
  AS_IF([test "x${enable_dependency_tracking}" = "x"],[
    enable_dependency_tracking=yes
  ])
  
  gl_USE_SYSTEM_EXTENSIONS
  
  dnl Once we can use a modern autoconf, we can use this
  dnl AC_PROG_CC_C99
  AC_PROG_CXX
  AC_PROG_CPP
  AM_PROG_CC_C_O
  
  PANDORA_LIBTOOL

  AC_C_BIGENDIAN
  AC_C_CONST
  AC_HEADER_TIME
  AC_TYPE_SIZE_T
  AC_FUNC_MALLOC
  AC_FUNC_REALLOC
  

  AC_CHECK_DECL([__SUNPRO_C], [SUNCC="yes"], [SUNCC="no"])
  PANDORA_CHECK_C_VERSION
  PANDORA_CHECK_CXX_VERSION

  PANDORA_MAC_GCC42

  PANDORA_OPTIMIZE
  PANDORA_64BIT
  PANDORA_WARNINGS

  gl_VISIBILITY

  PANDORA_ENABLE_DTRACE
  PANDORA_HEADER_ASSERT

  AC_CHECK_PROGS([DOXYGEN], [doxygen])
  AC_CHECK_PROGS([PERL], [perl])

  AS_IF([test "x${gl_LIBOBJS}" != "x"],[
    AS_IF([test "$GCC" = "yes"],[
      AM_CPPFLAGS="-isystem \$(top_srcdir)/gnulib -isystem \$(top_builddir)/gnulib ${AM_CPPFLAGS}"
    ],[
    AM_CPPFLAGS="-I\$(top_srcdir)/gnulib -I\$(top_builddir)/gnulib ${AM_CPPFLAGS}"
    ])
  ])

  AM_CPPFLAGS="-I\${top_srcdir} -I\${top_builddir} ${AM_CPPFLAGS}"
  AM_CFLAGS="${AM_CFLAGS} ${CC_WARNINGS} ${CC_PROFILING} ${CC_COVERAGE}"
  AM_CXXFLAGS="${AM_CXXFLAGS} ${CXX_WARNINGS} ${CC_PROFILING} ${CC_COVERAGE}"

  AC_SUBST([AM_CFLAGS])
  AC_SUBST([AM_CXXFLAGS])
  AC_SUBST([AM_CPPFLAGS])

])
