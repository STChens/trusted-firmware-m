::  Make sure setenv.bat is executed once before running this script
@echo off
call setenv.bat 

set WORK_DIR=c:/ST/Cube/TFM
set toolchain=gnu
set BUILD_DIR_S=build_s

mkdir %WORK_DIR%/%toolchain%
cd %WORK_DIR%/%toolchain%
rd /s/q  %BUILD_DIR_S%

set WORK_DIR=%WORK_DIR:\=/%
set BUILD_DIR_S=%WORK_DIR%/%toolchain%/build_s
cd %WORK_DIR%

set TFM_SOURCE=%WORK_DIR%/trusted-firmware-m
set TOOL_CHAIN=%TFM_SOURCE%/toolchain_GNUARM.cmake
set TARGET=stm/stm32h573i_dk

:: profile
set PROFILE=profile_medium

::  library
::  MCUBOOT_SRC=-DMCUBOOT_PATH=%WORK_DIR%/mcuboot-src
::  MBEDCRYPTO_SRC=-DMBEDCRYPTO_PATH=%WORK_DIR%/mbedtls
::  TF_PSA_CRYPTO_SRC=-DTF_PSA_CRYPTO_PATH=%WORK_DIR%/tf-psa-crypto-src
::  TFMTEST_SRC=%WORK_DIR%/tf-m-tests/tests_reg/spe
::  QCBOR=-DQCBOR_PATH=%WORK_DIR%/qcbor-src
::  TFM_EXTRAS=-DTFM_EXTRAS_REPO_PATH=%WORK_DIR%/tf-m-extras-src
::  BUILD_TYPE=RelWithDebInfo
::  BUILD_TYPE=Debug
set MBED_BUILD_TYPE=RelWithDebInfo
::  MBED_BUILD_TYPE=Debug

set BUILD_VERBOSE=ON
:: BUILD_VERBOSE=OFF

::  log file
set logfile=%WORK_DIR%/%toolchain%/build_s_bat.log

:: cmake -S %TFMTEST_SRC% -B %BUILD_TFM% %MCUBOOT_SRC% %TF_PSA_CRYPTO_SRC% %QCBOR% %TFM_EXTRAS% %SIGN_IMAG% %TFM_CONFIG% /
::       -GNinja %TARGET% %TOOL_CHAIN% -DCONFIG_TFM_SOURCE_PATH=%TFM_SOURCE% /
::       -DCMAKE_BUILD_TYPE=%BUILD_TYPE% %PROFILE% -DTFM_PSA_API=ON -DTFM_ISOLATION_LEVEL=2 /
::       -DTEST_S=ON -DTEST_NS=ON -DTEST_S_CRYPTO=ON -DTEST_NS_CRYPTO=ON

echo "cmake -S %TFM_SOURCE% -B %BUILD_DIR_S% -GNinja -DTFM_PLATFORM=%TARGET% -DTFM_TOOLCHAIN_FILE=%TOOL_CHAIN% -DCMAKE_BUILD_TYPE=%MBED_BUILD_TYPE% -DTFM_ISOLATION_LEVEL=2 -DTFM_PROFILE=%PROFILE% -DCMAKE_VERBOSE_MAKEFILE=%BUILD_VERBOSE%"

echo "Start configuration"

cmake -S %TFM_SOURCE% -B %BUILD_DIR_S% -GNinja -DTFM_PLATFORM=%TARGET% -DTFM_TOOLCHAIN_FILE=%TOOL_CHAIN% -DCMAKE_BUILD_TYPE=%MBED_BUILD_TYPE% -DTFM_ISOLATION_LEVEL=2 -DTFM_PROFILE=%PROFILE% -DCMAKE_VERBOSE_MAKEFILE=%BUILD_VERBOSE% > %logfile% 2>&1

echo "cmake --build %BUILD_DIR_S% -- install >> %logfile% 2>&1"

cmake --build %BUILD_DIR_S% -- install >> %logfile% 2>&1

:: ninja -C %BUILD_TFM% -j12 install
pause