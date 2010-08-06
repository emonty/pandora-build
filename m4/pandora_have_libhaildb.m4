dnl  Copyright (C) 2009 Sun Microsystems
dnl This file is free software; Sun Microsystems
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([_PANDORA_SEARCH_LIBHAILDB],[
  AC_REQUIRE([AC_LIB_PREFIX])

  dnl --------------------------------------------------------------------
  dnl  Check for libhaildb
  dnl --------------------------------------------------------------------

  AC_ARG_ENABLE([libhaildb],
    [AS_HELP_STRING([--disable-libhaildb],
      [Build with libhaildb support @<:@default=on@:>@])],
    [ac_enable_libhaildb="$enableval"],
    [ac_enable_libhaildb="yes"])

  AS_IF([test "x$ac_enable_libhaildb" = "xyes"],[
    AC_LIB_HAVE_LINKFLAGS(haildb,,[
      #include <haildb.h>
    ],[
      ib_u64_t
      ib_api_version(void);
    ])
  ],[
    ac_cv_libhaildb="no"
  ])


  AC_CACHE_CHECK([if libhaildb is recent enough],
    [ac_cv_recent_haildb_h],[
      save_LIBS=${LIBS}
      LIBS="${LIBS} ${LTLIBHAILDB}"
      AC_LINK_IFELSE(
          [AC_LANG_PROGRAM([[
      #include <haildb.h>
        ]],[[
      /* Make sure we have the two-arg version */
      ib_table_drop(NULL, "nothing");
        ]])],[
        ac_cv_recent_haildb_h=yes
      ],[
        ac_cv_recent_haildb_h=no
      ])
      LIBS="${save_LIBS}"
    ])
  AS_IF([test "x${ac_cv_recent_haildb_h}" = "xno"],[
    AC_MSG_WARN([${PACKAGE} requires at least version 1.0.6 of Embedded InnoDB])
    ac_cv_libhaildb=no
  ])
        
  AM_CONDITIONAL(HAVE_LIBHAILDB, [test "x${ac_cv_libhaildb}" = "xyes"])
])

AC_DEFUN([PANDORA_HAVE_LIBHAILDB],[
  AC_REQUIRE([_PANDORA_SEARCH_LIBHAILDB])
])

AC_DEFUN([PANDORA_REQUIRE_LIBHAILDB],[
  AC_REQUIRE([PANDORA_HAVE_LIBHAILDB])
  AS_IF([test "x${ac_cv_libhaildb}" = "xno"],
      AC_MSG_ERROR([libhaildb is required for ${PACKAGE}]))
])
