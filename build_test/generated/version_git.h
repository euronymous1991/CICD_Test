#ifndef VERSION_GIT_H
#define VERSION_GIT_H

/* Auto-generated at build time by cmake/version.cmake -- do not edit */
/* Do not commit this file (it lives in build/generated/) */

#define FW_GIT_HASH     "8a47492"
#define FW_GIT_DIRTY    1
#define FW_BUILD_DATE   "2026-03-02"
#define FW_BUILD_TIME   "19:45:38"

/* Full version string examples:
 *   Clean commit:  "1.0.0-a3f2c1d"
 *   Dirty tree:    "1.0.0-a3f2c1d-dirty"
 */
#if FW_GIT_DIRTY
#define FW_VERSION_FULL  FW_VERSION_STR "-" FW_GIT_HASH "-dirty"
#else
#define FW_VERSION_FULL  FW_VERSION_STR "-" FW_GIT_HASH
#endif

#endif /* VERSION_GIT_H */
