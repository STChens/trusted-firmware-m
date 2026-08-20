# Make sure setenv.sh is executed once before running this script
# Make sure gnu_build_s.sh is executed before running this script

WORK_DIR=/c/ST/Cube/TFM
toolchain=iar
BUILD_DIR_S=$WORK_DIR/$toolchain/build_s
BUILD_DIR_NS=$WORK_DIR/$toolchain/build_ns
#rm -rf $BUILD_DIR_NS
#mkdir -p $BUILD_DIR_NS

TFM_SOURCE=$WORK_DIR/trusted-firmware-m
TOOL_CHAIN=$BUILD_DIR_S/api_ns/cmake/toolchain_ns_IARARM.cmake
TARGET=stm/stm32h573i_dk

#profile
PROFILE=profile_medium

# library
# MCUBOOT_SRC=-DMCUBOOT_PATH=%WORK_DIR%/mcuboot-src
# MBEDCRYPTO_SRC=-DMBEDCRYPTO_PATH=%WORK_DIR%/mbedtls
# TF_PSA_CRYPTO_SRC=-DTF_PSA_CRYPTO_PATH=%WORK_DIR%/tf-psa-crypto-src
TFMTEST_SRC=$WORK_DIR/tf-m-tests/tests_reg
# QCBOR=-DQCBOR_PATH=%WORK_DIR%/qcbor-src
# TFM_EXTRAS=-DTFM_EXTRAS_REPO_PATH=%WORK_DIR%/tf-m-extras-src
# BUILD_TYPE=RelWithDebInfo
# BUILD_TYPE=Debug
MBED_BUILD_TYPE=RelWithDebInfo
# MBED_BUILD_TYPE=Debug

BUILD_VERBOSE=ON
#BUILD_VERBOSE=OFF


# log file
logfile=$WORK_DIR/$toolchain/build_ns_sh.log

echo "cmake -S $TFMTEST_SRC -B $BUILD_DIR_NS -GNinja \
      -DCONFIG_SPE_PATH=$BUILD_DIR_S/api_ns -DTFM_TOOLCHAIN_FILE=$TOOL_CHAIN \
      -DCMAKE_BUILD_TYPE=$MBED_BUILD_TYPE  -DTFM_NS_REG_TEST=ON -DTEST_NS_CRYPTO=ON -DTEST_NS_ITS=ON \
      -DCMAKE_VERBOSE_MAKEFILE=$BUILD_VERBOSE > $logfile 2>&1"

#echo "Press enter to continue"
#read 

echo "Start tf-m-test NS configuration"

cmake -S $TFMTEST_SRC -B $BUILD_DIR_NS -GNinja \
      -DCONFIG_SPE_PATH=$BUILD_DIR_S/api_ns -DTFM_TOOLCHAIN_FILE=$TOOL_CHAIN \
      -DCMAKE_BUILD_TYPE=$MBED_BUILD_TYPE  -DTFM_NS_REG_TEST=ON -DTEST_NS_CRYPTO=ON -DTEST_NS_ITS=ON \
      -DCMAKE_VERBOSE_MAKEFILE=$BUILD_VERBOSE > $logfile 2>&1

echo "cmake --build $BUILD_DIR_NS  >> $logfile 2>&1"

cmake --build $BUILD_DIR_NS  >> $logfile 2>&1

#ninja -C %BUILD_TFM% -j12 install
