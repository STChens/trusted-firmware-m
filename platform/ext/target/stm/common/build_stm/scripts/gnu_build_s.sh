# Make sure setenv.sh is executed once before running this script

WORK_DIR=$PWD
toolchain=gnu
BUILD_DIR_S=$WORK_DIR/$toolchain/build_s
rm -rf $BUILD_DIR_S
mkdir -p $BUILD_DIR_S

TFM_SOURCE=$WORK_DIR/trusted-firmware-m
TOOL_CHAIN=$TFM_SOURCE/toolchain_GNUARM.cmake
TARGET=stm/stm32h573i_dk

#profile
#PROFILE=profile_medium
PROFILE=profile_large

# library
# MCUBOOT_SRC=-DMCUBOOT_PATH=%WORK_DIR%/mcuboot-src
# MBEDCRYPTO_SRC=-DMBEDCRYPTO_PATH=%WORK_DIR%/mbedtls
# TF_PSA_CRYPTO_SRC=-DTF_PSA_CRYPTO_PATH=%WORK_DIR%/tf-psa-crypto-src
# TFMTEST_SRC=$WORK_DIR/tf-m-tests/tests_reg/spe
# QCBOR=-DQCBOR_PATH=%WORK_DIR%/qcbor-src
# TFM_EXTRAS=-DTFM_EXTRAS_REPO_PATH=%WORK_DIR%/tf-m-extras-src
# BUILD_TYPE=RelWithDebInfo
# BUILD_TYPE=Debug
MBED_BUILD_TYPE=RelWithDebInfo
# MBED_BUILD_TYPE=Debug

BUILD_VERBOSE=ON
#BUILD_VERBOSE=OFF

# log file
logfile=$WORK_DIR/$toolchain/build_s_sh.log

#cmake -S %TFMTEST_SRC% -B %BUILD_TFM% %MCUBOOT_SRC% %TF_PSA_CRYPTO_SRC% %QCBOR% %TFM_EXTRAS% %SIGN_IMAG% %TFM_CONFIG% \
#      -GNinja %TARGET% %TOOL_CHAIN% -DCONFIG_TFM_SOURCE_PATH=%TFM_SOURCE% \
#      -DCMAKE_BUILD_TYPE=%BUILD_TYPE% %PROFILE% -DTFM_PSA_API=ON -DTFM_ISOLATION_LEVEL=2 \
#      -DTEST_S=ON -DTEST_NS=ON -DTEST_S_CRYPTO=ON -DTEST_NS_CRYPTO=ON

echo "cmake -S $TFM_SOURCE -B $BUILD_DIR_S -GNinja -DTFM_PLATFORM=$TARGET \
      -DTFM_TOOLCHAIN_FILE=$TOOL_CHAIN -DCMAKE_BUILD_TYPE=$MBED_BUILD_TYPE -DTFM_ISOLATION_LEVEL=2 \
      -DTFM_PROFILE=$PROFILE -DCMAKE_VERBOSE_MAKEFILE=$BUILD_VERBOSE"

#echo "Press enter to continue"
#read 
echo "Start TF-M S configuration"

cmake -S $TFM_SOURCE -B $BUILD_DIR_S -GNinja -DTFM_PLATFORM=$TARGET \
      -DTFM_TOOLCHAIN_FILE=$TOOL_CHAIN -DCMAKE_BUILD_TYPE=$MBED_BUILD_TYPE -DTFM_ISOLATION_LEVEL=2 \
      -DTFM_PROFILE=$PROFILE -DCMAKE_VERBOSE_MAKEFILE=$BUILD_VERBOSE > $logfile 2>&1

echo "cmake --build $BUILD_DIR_S -- install >> $logfile 2>&1"

cmake --build $BUILD_DIR_S -- install >> $logfile 2>&1

#ninja -C %BUILD_TFM% -j12 install
