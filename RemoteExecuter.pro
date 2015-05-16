TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

#supporto per la traduzione
lupdate_only{
SOURCES = *.qml \
          *.js
}
TRANSLATIONS += translations/remoteexecuter_default.ts

RESOURCES += qml.qrc \
    immagini.qrc \
    componenti.qrc \
    translations.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

include(QtLibSSH/QtLibSSH.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    ToDo.txt

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
