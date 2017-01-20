 #!/bin/sh
ARCH="arm"
ANDROID_NDK_ROOT="/home/pxpert/Android/android-ndk-r13b/"
ANDROID_NDK="android-ndk-r13b"
ANDROID_EABI="arm-linux-androideabi-4.9"
ANDROID_ARCH=arch-arm
ANDROID_API="android-14"
ANDROID_SYSTEM="linux-x86_64"
 
LIBSSH=libssh-0.6.5
OPENSSL=openssl-1.0.2j

rm -rf tmp/*
rm -rf android/$ARCH

cd tmp
tar xf ../deps/$OPENSSL.tar.gz
tar xf ../deps/$LIBSSH.tar.xz
cd $LIBSSH
patch -p1 < ../../deps/android-patch.patch
cd ../..
. deps/setenv-android.sh $ANDROID_NDK $ANDROID_EABI $ANDROID_ARCH $ANDROID_API $ANDROID_NDK_ROOT

# exit 0


cd tmp/$OPENSSL
perl -pi -e 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile.org
./config shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=`pwd`/../../android/$ARCH
make depend
make all
make install CC=$ANDROID_TOOLCHAIN/"$CROSS_COMPILE"gcc RANLIB=$ANDROID_TOOLCHAIN/"$CROSS_COMPILE"ranlib

cd ../

# $ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh --ndk-dir=$ANDROID_NDK_ROOT --system=linux-x86_64 --install-dir=`pwd`/toolchain
$ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh --install-dir=`pwd`/toolchain --toolchain=$ANDROID_EABI --platform=$ANDROID_API
mkdir libssh-build
cd libssh-build
# export PROVA=\'`pwd`/../../android/$ARCH/lib/libcrypto.a `pwd`/../../android/$ARCH/lib/libssl.a\'

cmake ../$LIBSSH -DCMAKE_SYSTEM_PROCESSOR=$ARCH -DCMAKE_SYSTEM_VERSION=1 \
-DCMAKE_C_COMPILER=`pwd`/../toolchain/bin/"$CROSS_COMPILE"gcc -DCMAKE_FIND_ROOT_PATH=`pwd`/../toolchain/sysroot/ \
-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=0 \
-DWITH_ZLIB=1 -DOPENSSL_INCLUDE_DIRS=`pwd`/../../android/$ARCH/include/ \
-DOPENSSL_CRYPTO_LIBRARIES="-l`pwd`/../../android/$ARCH/lib/libcrypto.a" -DOPENSSL_SSL_LIBRARIES="-l`pwd`/../../android/$ARCH/lib/libssl.a" -DWITH_SERVER=0 -DWITH_EXAMPLES=0 \
-DCMAKE_INSTALL_PREFIX=`pwd`/../../android/$ARCH -DWITH_STATIC_LIB=1 

make
make install
