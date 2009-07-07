dnl  Copyright (C) 2009 Sun Microsystems
dnl This file is free software; Sun Microsystems
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl ---------------------------------------------------------------------------
dnl Macro: PANDORA_ENABLE_DTRACE
dnl ---------------------------------------------------------------------------
AC_DEFUN([PANDORA_ENABLE_DTRACE],[
  AC_ARG_ENABLE([dtrace],
    [AS_HELP_STRING([--enable-dtrace],
            [Build with support for the DTRACE. @<:@default=off@:>@])],
    [ac_cv_enable_dtrace="yes"],
    [ac_cv_enable_dtrace="no"])

  AS_IF([test "$ac_cv_enable_dtrace" = "yes"],[
    AC_CHECK_PROGS([DTRACE], [dtrace])
    AS_IF([test "x$ac_cv_prog_DTRACE" = "xdtrace"],[
      AC_DEFINE([HAVE_DTRACE], [1], [Enables DTRACE Support])
      AC_SUBST(DTRACEFLAGS) dnl TODO: test for -G on OSX
      ac_cv_have_dtrace=yes
    ])])

AM_CONDITIONAL([HAVE_DTRACE], [ test "x$ac_cv_have_dtrace" = "xyes" ])
])
dnl ---------------------------------------------------------------------------
dnl End Macro: PANDORA_ENABLE_DTRACE
dnl ---------------------------------------------------------------------------
