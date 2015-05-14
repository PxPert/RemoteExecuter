#include <QApplication>
#include <QQmlApplicationEngine>

#include <QQmlEngine>

#include "QtLibSSH/sessionessh.h"
#include <QtQml>

#include <QObject>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qRegisterMetaType<CodiceErrore>("CodiceErrore");
    qRegisterMetaTypeStreamOperators<CodiceErrore>("CodiceErrore");

    qmlRegisterType<CodiceErrore>("org.pxpert.CodiceErrore", 1, 0, "CodiceErrore");
    qmlRegisterType<SessioneSSH>("org.pxpert.SessioneSSH", 1, 0, "SessioneSSH");


    QObject::connect(&engine, SIGNAL(quit()), &app, SLOT(quit())); // to make Qt.quit() to work.

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
