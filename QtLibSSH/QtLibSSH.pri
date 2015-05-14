android {
    equals(ANDROID_TARGET_ARCH, x86)  {
        message("TODO X86")
    } else {
#        LIBS += -l$$PWD/android/arm/lib/libcrypto.so
#        LIBS += -l$$PWD/android/arm/lib/libssl.so
        LIBS += -l$$PWD/android/arm/lib/libssh.so

        INCLUDEPATH += $$PWD/android/arm/include/
#        ANDROID_EXTRA_LIBS += $$PWD/android/arm/lib/libssl.so
#        ANDROID_EXTRA_LIBS += $$PWD/android/arm/lib/libcrypto.so
        ANDROID_EXTRA_LIBS += $$PWD/android/arm/lib/libssh.so
    }
} else {
    LIBS += -lssh
}
 

HEADERS += \
    $$PWD/sessionessh.h

SOURCES += \
    $$PWD/sessionessh.cpp

