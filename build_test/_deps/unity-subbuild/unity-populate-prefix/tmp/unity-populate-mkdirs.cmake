# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-src")
  file(MAKE_DIRECTORY "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-src")
endif()
file(MAKE_DIRECTORY
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-build"
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix"
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/tmp"
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/src/unity-populate-stamp"
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/src"
  "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/src/unity-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/src/unity-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/_deps/unity-subbuild/unity-populate-prefix/src/unity-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
