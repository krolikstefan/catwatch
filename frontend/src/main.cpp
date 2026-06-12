#include "ApiClient.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName(QStringLiteral("KotekWatch"));
    QGuiApplication::setApplicationName(QStringLiteral("KotekWatchFrontend"));
    QQuickStyle::setStyle(QStringLiteral("Basic"));

    ApiClient apiClient;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("apiClient"), &apiClient);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() {
        QCoreApplication::exit(1);
    }, Qt::QueuedConnection);
    engine.load(QUrl(QStringLiteral("qrc:/KotekWatch/qml/Main.qml")));

    return app.exec();
}
