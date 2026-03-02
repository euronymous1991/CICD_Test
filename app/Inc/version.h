#ifndef VERSION_H
#define VERSION_H

/**
 * @file  version.h
 * @brief Firmware semantic version -- edit this manually on each release.
 *
 * Versioning rules:
 *   MAJOR -- breaking change or major milestone
 *   MINOR -- new feature, backward compatible
 *   PATCH -- bug fix only
 *
 * After bumping the version:
 *   1. Update the three defines below
 *   2. Update FW_VERSION_STR to match
 *   3. git tag -a v1.0.0 -m "Release 1.0.0"
 *   4. git push origin v1.0.0
 */

#define FW_VERSION_MAJOR  1
#define FW_VERSION_MINOR  0
#define FW_VERSION_PATCH  1

#define FW_VERSION_STR    "1.0.1"

#endif /* VERSION_H */