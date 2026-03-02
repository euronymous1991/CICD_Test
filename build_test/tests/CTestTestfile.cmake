# CMake generated Testfile for 
# Source directory: D:/CI_CD/test1/stm32-nucleo-cicd/tests
# Build directory: D:/CI_CD/test1/stm32-nucleo-cicd/build_test/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test([=[test_led_manager]=] "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/tests/test_led_manager.exe")
set_tests_properties([=[test_led_manager]=] PROPERTIES  _BACKTRACE_TRIPLES "D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;40;add_test;D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;43;add_unit_test;D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;0;")
add_test([=[test_uart_logger]=] "D:/CI_CD/test1/stm32-nucleo-cicd/build_test/tests/test_uart_logger.exe")
set_tests_properties([=[test_uart_logger]=] PROPERTIES  _BACKTRACE_TRIPLES "D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;40;add_test;D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;51;add_unit_test;D:/CI_CD/test1/stm32-nucleo-cicd/tests/CMakeLists.txt;0;")
subdirs("../_deps/unity-build")
