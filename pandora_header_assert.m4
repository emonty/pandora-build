dnl PANDORA_HEADER_ASSERT
dnl ----------------
dnl Check whether to enable assertions.
AC_DEFUN([PANDORA_HEADER_ASSERT],
[
  AC_MSG_CHECKING([whether to enable assertions])
  AC_ARG_ENABLE([assert],
    [AS_HELP_STRING([--disable-assert],
       [Turn off assertions])],
    [ac_cv_assert="no"],
    [ac_cv_assert="yes"])
  AC_MSG_RESULT([$ac_cv_assert])

  AS_IF([test "$ac_cv_assert" = "yes"], 
    [AC_CHECK_HEADERS(assert.h)],
    [AC_DEFINE(NDEBUG, 1, [Define to 1 if assertions should be disabled.])])
])

