::  Make sure setenv.bat is executed once before running this script
::  Make sure gnu_build_s.bat is executed before running this script
call setenv.bat

set WORK_DIR=c:/ST/Cube/TFM
set toolchain=gnu
set BUILD_DIR_S=%WORK_DIR%/%toolchain%/build_s
set BUILD_DIR_NS=%WORK_DIR%/%toolchain%/build_ns
rd /S/Q %BUILD_DIR_NS%
mkdir %BUILD_DIR_NS%

set WORK_DIR=%WORK_DIR:\=/%
set TFM_SOURCE=%WORK_DIR%/trusted-firmware-m
set TOOL_CHAIN=%BUILD_DIR_S%/api_ns/cmake/toolchain_ns_GNUARM.cmake
set TARGET=stm/stm32h573i_dk

:: profile
set PROFILE=profile_medium

::  library
::  MCUBOOT_SRC=-DMCUBOOT_PATH=%WORK_DIR%/mcuboot-src
::  MBEDCRYPTO_SRC=-DMBEDCRYPTO_PATH=%WORK_DIR%/mbedtls
::  TF_PSA_CRYPTO_SRC=-DTF_PSA_CRYPTO_PATH=%WORK_DIR%/tf-psa-crypto-src
set TFMTEST_SRC=%WORK_DIR%/tf-m-tests/tests_reg
::  QCBOR=-DQCBOR_PATH=%WORK_DIR%/qcbor-src
::  TFM_EXTRAS=-DTFM_EXTRAS_REPO_PATH=%WORK_DIR%/tf-m-extras-src
::  BUILD_TYPE=RelWithDebInfo
::  BUILD_TYPE=Debug
set MBED_BUILD_TYPE=RelWithDebInfo
::  MBED_BUILD_TYPE=Debug

set BUILD_VERBOSE=ON
:: BUILD_VERBOSE=OFF


::  log file
set logfile=%WORK_DIR%/%toolchain%/build_ns_bat.log

echo "cmake -S %TFMTEST_SRC% -B %BUILD_DIR_NS% -GNinja -DCONFIG_SPE_PATH=%BUILD_DIR_S%/api_ns -DTFM_TOOLCHAIN_FILE=%TOOL_CHAIN% -DCMAKE_VERBOSE_MAKEFILE=%BUILD_VERBOSE% > %logfile% 2>&1"

cmake -S %TFMTEST_SRC% -B %BUILD_DIR_NS% -GNinja -DCONFIG_SPE_PATH=%BUILD_DIR_S%/api_ns -DTFM_TOOLCHAIN_FILE=%TOOL_CHAIN% -DCMAKE_VERBOSE_MAKEFILE=%BUILD_VERBOSE% > %logfile% 2>&1

echo "cmake --build %BUILD_DIR_NS%  >> %logfile% 2>&1"

cmake --build %BUILD_DIR_NS%  >> %logfile% 2>&1

:: ninja -C %BUILD_TFM% -j12 install
pause