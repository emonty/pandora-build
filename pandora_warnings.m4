dnl AC_PANDORA_WARNINGS([FULL],[VC_WARNING_OFF])
dnl   FULL whether to turn on the full or the limited set of warnings.
dnl        defaults to yes
dnl   VC_WARNING_OFF whether to disable warnings=error for tarball builds
dnl                  defaults to yes
 
AC_DEFUN([PANDORA_WARNINGS],[
  m4_define([_PANDORA_WARNINGS_FULL], [m4_if($1, no, no, yes)])
  m4_define([_PANDORA_VC_WARNING_OFF], [m4_if($2, no, no, yes)])

  AC_REQUIRE([PANDORA_BUILDING_FROM_VC])
  AS_IF([test _PANDORA_VC_WARNING_OFF = "no" -o "$ac_cv_building_from_vc" = "yes"],
    [ac_cv_warnings_as_errors=yes],
    [ac_cv_warnings_as_errors=no])

  AC_ARG_ENABLE([profiling],
      [AS_HELP_STRING([--enable-profiling],
         [Toggle profiling @<:@default=off@:>@])],
      [ac_profiling="$enableval"],
      [ac_profiling="no"])

  AC_ARG_ENABLE([coverage],
      [AS_HELP_STRING([--enable-coverage],
         [Toggle coverage @<:@default=off@:>@])],
      [ac_coverage="$enableval"],
      [ac_coverage="no"])

  AS_IF([test "$GCC" = "yes"],[

    AS_IF([test "$ac_profiling" = "yes"],
          [CC_PROFILING="-pg"])

    AS_IF([test "$ac_coverage" = "yes"],
          [CC_COVERAGE="-fprofile-arcs -ftest-coverage"])
	 
    AS_IF([test "$ac_cv_warnings_as_errors" = "yes"],
          [W_FAIL="-Werror"])

    AC_CACHE_CHECK([whether it is safe to use -fdiagnostics-show-option],
      [ac_cv_safe_to_use_fdiagnostics_show_option_],
      [save_CFLAGS="$CFLAGS"
       CFLAGS="-fdiagnostics-show-option ${AM_CFLAGS}"
       AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([],[])],
         [ac_cv_safe_to_use_fdiagnostics_show_option_=yes],
         [ac_cv_safe_to_use_fdiagnostics_show_option_=no])
       CFLAGS="$save_CFLAGS"])

    AS_IF([test "$ac_cv_safe_to_use_fdiagnostics_show_option_" = "yes"],
          [
            F_DIAGNOSTICS_SHOW_OPTION="-fdiagnostics-show-option"
          ])

    AC_CACHE_CHECK([whether it is safe to use -Wconversion],
      [ac_cv_safe_to_use_wconversion_],
      [save_CFLAGS="$CFLAGS"
       CFLAGS="-Wconversion ${W_FAIL} -pedantic ${AM_CFLAGS}"
       AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([[
#include <stdbool.h>
void foo(bool a)
{
  (void)a;
}
         ]],[[
foo(0);
         ]])],
         [ac_cv_safe_to_use_wconversion_=yes],
         [ac_cv_safe_to_use_wconversion_=no])
       CFLAGS="$save_CFLAGS"])

    AS_IF([test "$ac_cv_safe_to_use_wconversion_" = "yes"],
      [W_CONVERSION="-Wconversion"
      AC_CACHE_CHECK([whether it is safe to use -Wconversion with htons],
        [ac_cv_safe_to_use_Wconversion_],
        [save_CFLAGS="$CFLAGS"
         CFLAGS="-Wconversion ${W_FAIL} -pedantic ${AM_CFLAGS}"
         AC_COMPILE_IFELSE(
           [AC_LANG_PROGRAM(
             [[
#include <netinet/in.h>
             ]],[[
uint16_t x= htons(80);
             ]])],
           [ac_cv_safe_to_use_Wconversion_=yes],
           [ac_cv_safe_to_use_Wconversion_=no])
         CFLAGS="$save_CFLAGS"])

      AS_IF([test "$ac_cv_safe_to_use_Wconversion_" = "no"],
            [NO_CONVERSION="-Wno-conversion"])
    ])


    BASE_WARNINGS="-pedantic -Wall -Wextra ${W_FAIL} -Wundef -Wshadow -Wmissing-declarations -Wstrict-aliasing -Wformat=2 ${F_DIAGNOSTICS_SHOW_OPTION} ${CFLAG_VISIBILITY} ${W_CONVERSION}"
    CC_WARNINGS="${BASE_WARNINGS} -Wstrict-prototypes -Wmissing-prototypes -Wredundant-decls -Wswitch-default -Wswitch-enum -Wcast-align"
    CXX_WARNINGS="${BASE_WARNINGS} -Woverloaded-virtual -Wnon-virtual-dtor -Wctor-dtor-privacy -Wold-style-cast -Weffc++ -Wno-long-long"

    AC_CACHE_CHECK([whether it is safe to use -Wlogical-op],
      [ac_cv_safe_to_use_Wlogical_op_],
      [save_CFLAGS="$CFLAGS"
       CFLAGS="-Wlogical-op -Werror -pedantic ${AM_CFLAGS}"
       AC_COMPILE_IFELSE([
         AC_LANG_PROGRAM(
         [[
#include <stdio.h>
         ]], [[]])
      ],
      [ac_cv_safe_to_use_Wlogical_op_=yes],
      [ac_cv_safe_to_use_Wlogical_op_=no])
    CFLAGS="$save_CFLAGS"])
    AS_IF([test "$ac_cv_safe_to_use_Wlogical_op_" = "yes"],
          [CC_WARNINGS="${CC_WARNINGS} -Wlogical-op"])

    AC_CACHE_CHECK([whether it is safe to use -Wredundant-decls from C++],
      [ac_cv_safe_to_use_Wredundant_decls_],
      [AC_LANG_PUSH(C++)
       save_CXXFLAGS="${CXXFLAGS}"
       CXXFLAGS="-Wredundant-decls ${W_FAIL} -pedantic -Wredundant-decls"
       AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM([
template <typename E> struct C { void foo(); };
template <typename E> void C<E>::foo() { }
template <> void C<int>::foo();
          AC_INCLUDES_DEFAULT])],
          [ac_cv_safe_to_use_Wredundant_decls_=yes],
          [ac_cv_safe_to_use_Wredundant_decls_=no])
        CXXFLAGS="${save_CXXFLAGS}"
        AC_LANG_POP()])
    AS_IF([test "$ac_cv_safe_to_use_Wredundant_decls_" = "yes"],
          [CXX_WARNINGS="${CXX_WARNINGS} -Wredundant-decls"],
          [CXX_WARNINGS="${CXX_WARNINGS} -Wno-redundant-decls"])

    NO_REDUNDANT_DECLS="-Wno-redundant-decls"
    NO_STRICT_ALIASING="-fno-strict-aliasing -Wno-strict-aliasing"
    
  ])

  AS_IF([test "$SUNCC" = "yes"],[

    AS_IF([test "$ac_profiling" = "yes"],
          [CC_PROFILING="-xinstrument=datarace"])

    AS_IF([test "$ac_cv_warnings_as_errors" = "yes"],
          [W_FAIL="-errwarn=%all"])

    AC_CACHE_CHECK([whether E_PASTE_RESULT_NOT_TOKEN is usable],
      [ac_cv_paste_result],
      [
        save_CFLAGS="${CFLAGS}"
        CFLAGS="-errwarn=%all -erroff=E_PASTE_RESULT_NOT_TOKEN ${CFLAGS}"
        AC_COMPILE_IFELSE(
          [AC_LANG_PROGRAM([
            AC_INCLUDES_DEFAULT
          ],[
            int x= 0;])],
          [ac_cv_paste_result=yes],
          [ac_cv_paste_result=no])
        CFLAGS="${save_CFLAGS}"
      ])
    AS_IF([test $ac_cv_paste_result = yes],
      [W_PASTE_RESULT=",E_PASTE_RESULT_NOT_TOKEN"])


    CC_WARNINGS="-v -errtags=yes ${W_FAIL} -erroff=E_INTEGER_OVERFLOW_DETECTED${W_PASTE_RESULT}"
    CXX_WARNINGS="+w +w2 -xwe -xport64 -errtags=yes ${W_FAIL}"
  ])

  AC_SUBST(NO_CONVERSION)
  AC_SUBST(NO_REDUNDANT_DECLS)
  AC_SUBST(NO_STRICT_ALIASING)

])
