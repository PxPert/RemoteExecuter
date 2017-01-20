#include <QApplication>
#include <QQmlApplicationEngine>

#include <QQmlEngine>

#include "QtLibSSH/sessionessh.h"
#include <QtQml>
#include <QTranslator>

#include <QObject>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTranslator translator;
    QString locale = QLocale::system().name();

//    qDebug() << "LOCALE:" << locale;
    if (! locale.contains("it_",Qt::CaseInsensitive))
    {
        translator.load(QString(":/translations/remoteexecuter_default.ts"));

        app.installTranslator(&translator);
    }


    QQmlApplicationEngine engine;
    qRegisterMetaType<CodiceErrore>("CodiceErrore");
    qRegisterMetaTypeStreamOperators<CodiceErrore>("CodiceErrore");

    qmlRegisterType<CodiceErrore>("org.pxpert.CodiceErrore", 1, 0, "CodiceErrore");
    qmlRegisterType<SessioneSSH>("org.pxpert.SessioneSSH", 1, 0, "SessioneSSH");


    QObject::connect(&engine, SIGNAL(quit()), &app, SLOT(quit())); // to make Qt.quit() to work.

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
