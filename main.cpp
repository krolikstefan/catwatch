#include <QCoreApplication>
#include <QDir>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QUrl>

#include "watchbackend.h"

namespace {

void registerFont(const QString &sourceDir, const QString &fileName)
{
    const QString fontPath = QDir(sourceDir + "/fonts").filePath(fileName);
    QFontDatabase::addApplicationFont(fontPath);
}

}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationDisplayName(QStringLiteral("Kotek Watch"));

    registerFont(QStringLiteral(KOTEKWATCH_SOURCE_DIR), QStringLiteral("Fredoka-SemiBold.ttf"));
    registerFont(QStringLiteral(KOTEKWATCH_SOURCE_DIR), QStringLiteral("Nunito-Bold.ttf"));

    QQmlApplicationEngine engine;
    WatchBackend backend;
    engine.addImportPath(QStringLiteral("qrc:/"));
    engine.rootContext()->setContextProperty(QStringLiteral("watchBackend"), &backend);

    const QUrl mainUrl(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [mainUrl](QObject *object, const QUrl &objectUrl) {
            if (!object && objectUrl == mainUrl) {
                QCoreApplication::exit(-1);
                return;
            }

            auto *window = qobject_cast<QQuickWindow *>(object);
            if (!window) {
                return;
            }

            window->setFlags(window->flags() | Qt::FramelessWindowHint);
            window->showFullScreen();
        },
        Qt::QueuedConnection);

    engine.load(mainUrl);
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
