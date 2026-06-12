#include "ApiServer.h"

#include <QCoreApplication>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("KotekWatch"));
    QCoreApplication::setApplicationName(QStringLiteral("KotekWatchBackend"));

    const quint16 httpPort = qEnvironmentVariableIntValue("KOTEKWATCH_HTTP_PORT") > 0
        ? static_cast<quint16>(qEnvironmentVariableIntValue("KOTEKWATCH_HTTP_PORT"))
        : 8080;
    const quint16 wsPort = qEnvironmentVariableIntValue("KOTEKWATCH_WS_PORT") > 0
        ? static_cast<quint16>(qEnvironmentVariableIntValue("KOTEKWATCH_WS_PORT"))
        : 8081;

    ApiServer server;
    if (!server.start(httpPort, wsPort)) {
        return 1;
    }

    return app.exec();
}
