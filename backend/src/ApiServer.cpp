#include "ApiServer.h"

#include <QHostAddress>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTcpServer>
#include <QTcpSocket>
#include <QThread>
#include <QTimer>
#include <QUrlQuery>
#include <QDebug>
#include <QCryptographicHash>

ApiServer::ApiServer(QObject *parent)
    : QObject(parent)
{
    m_tcpServer = new QTcpServer(this);
    m_liveServer = new QTcpServer(this);
    m_networkManager = new QNetworkAccessManager(this);

    connect(m_networkManager, &QNetworkAccessManager::finished, this, &ApiServer::handleWeatherReply);
    connect(m_tcpServer, &QTcpServer::newConnection, this, &ApiServer::handleHttpConnection);
}

ApiServer::~ApiServer()
{
    if (m_simulationThread) {
        m_simulationThread->quit();
        m_simulationThread->wait();
    }
}

bool ApiServer::start(quint16 httpPort, quint16 wsPort)
{
    if (!m_database.initialize()) {
        return false;
    }

    m_simulator = new SensorSimulator(m_database.user(), m_database.latestActivity(), m_database.deviceStatus());
    m_simulationThread = new QThread(this);
    m_simulator->moveToThread(m_simulationThread);
    connect(m_simulationThread, &QThread::finished, m_simulator, &QObject::deleteLater);
    connect(m_simulator, &SensorSimulator::liveDataReady, this, &ApiServer::broadcastLivePayload);
    m_simulationThread->start();

    setupHttpServer(httpPort);
    setupLiveSocketServer(wsPort);

    if (!m_tcpServer->isListening() || !m_liveServer->isListening()) {
        return false;
    }

    QTimer::singleShot(0, this, &ApiServer::fetchWeather);

    auto weatherTimer = new QTimer(this);
    weatherTimer->setInterval(30 * 60 * 1000);
    connect(weatherTimer, &QTimer::timeout, this, &ApiServer::fetchWeather);
    weatherTimer->start();

    QMetaObject::invokeMethod(m_simulator, "start", Qt::QueuedConnection);
    qInfo() << "HTTP API listening on port" << httpPort;
    qInfo() << "WebSocket listening on port" << wsPort;
    return true;
}

void ApiServer::broadcastLivePayload(const QJsonObject &payload)
{
    if (payload.contains(QStringLiteral("activity"))) {
        m_database.saveActivity(activityFromJson(payload.value(QStringLiteral("activity")).toObject()));
    }

    if (payload.contains(QStringLiteral("deviceStatus"))) {
        m_database.saveDeviceStatus(deviceStatusFromJson(payload.value(QStringLiteral("deviceStatus")).toObject()));
    }

    const QJsonArray milestones = payload.value(QStringLiteral("milestones")).toArray();
    for (const auto &entry : milestones) {
        const QJsonObject object = entry.toObject();
        m_database.addNotification(
            object.value(QStringLiteral("message")).toString(),
            QStringLiteral("milestone"),
            QDateTime::currentDateTimeUtc());
    }

    const bool running = payload.value(QStringLiteral("running")).toBool(m_simulationRunning);
    m_simulationRunning = running;

    const QByteArray message = QJsonDocument(payload).toJson(QJsonDocument::Compact);
    for (auto it = m_clients.begin(); it != m_clients.end();) {
        if (!*it) {
            it = m_clients.erase(it);
            continue;
        }

        (*it)->write(makeWebSocketFrame(message));
        ++it;
    }
}

void ApiServer::fetchWeather()
{
    const QString apiKey = qEnvironmentVariable("OPENWEATHER_API_KEY");
    if (apiKey.isEmpty()) {
        return;
    }

    const QString lat = qEnvironmentVariable("KOTEKWATCH_WEATHER_LAT", "52.2297");
    const QString lon = qEnvironmentVariable("KOTEKWATCH_WEATHER_LON", "21.0122");

    QUrl url(QStringLiteral("https://api.openweathermap.org/data/2.5/forecast"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("lat"), lat);
    query.addQueryItem(QStringLiteral("lon"), lon);
    query.addQueryItem(QStringLiteral("appid"), apiKey);
    query.addQueryItem(QStringLiteral("units"), QStringLiteral("metric"));
    query.addQueryItem(QStringLiteral("cnt"), QStringLiteral("16"));
    url.setQuery(query);

    m_networkManager->get(QNetworkRequest(url));
}

void ApiServer::handleWeatherReply(QNetworkReply *reply)
{
    if (!reply->error()) {
        const QJsonDocument document = QJsonDocument::fromJson(reply->readAll());
        const QJsonArray list = document.object().value(QStringLiteral("list")).toArray();
        if (!list.isEmpty()) {
            const QJsonObject current = list.first().toObject();
            const QJsonArray currentWeather = current.value(QStringLiteral("weather")).toArray();
            WeatherData weather;
            weather.timestamp = QDateTime::currentDateTimeUtc();
            weather.currentTemp = current.value(QStringLiteral("main")).toObject().value(QStringLiteral("temp")).toDouble();
            weather.currentDescription = currentWeather.isEmpty()
                ? QStringLiteral("Brak opisu")
                : currentWeather.first().toObject().value(QStringLiteral("description")).toString();

            double minTemp = weather.currentTemp;
            double maxTemp = weather.currentTemp;
            QString tomorrowDescription = weather.currentDescription;
            const QDate tomorrow = QDate::currentDate().addDays(1);

            for (const auto &entryValue : list) {
                const QJsonObject entry = entryValue.toObject();
                const QDateTime timestamp = QDateTime::fromSecsSinceEpoch(entry.value(QStringLiteral("dt")).toVariant().toLongLong()).toUTC();
                if (timestamp.date() != tomorrow) {
                    continue;
                }

                const QJsonObject main = entry.value(QStringLiteral("main")).toObject();
                const QJsonArray entryWeather = entry.value(QStringLiteral("weather")).toArray();
                minTemp = qMin(minTemp, main.value(QStringLiteral("temp_min")).toDouble());
                maxTemp = qMax(maxTemp, main.value(QStringLiteral("temp_max")).toDouble());
                if (!entryWeather.isEmpty()) {
                    tomorrowDescription = entryWeather.first().toObject().value(QStringLiteral("description")).toString();
                }
            }

            weather.tomorrowMin = minTemp;
            weather.tomorrowMax = maxTemp;
            weather.tomorrowDescription = tomorrowDescription;
            m_database.saveWeather(weather);
        }
    }

    reply->deleteLater();
}

void ApiServer::setupHttpServer(quint16 port)
{
    if (!m_tcpServer->listen(QHostAddress::LocalHost, port)) {
        qWarning() << "HTTP server failed to start on port" << port << m_tcpServer->errorString();
    }
}

void ApiServer::setupLiveSocketServer(quint16 port)
{
    if (!m_liveServer->listen(QHostAddress::LocalHost, port)) {
        qWarning() << "WebSocket server failed to start" << m_liveServer->errorString();
        return;
    }

    connect(m_liveServer, &QTcpServer::newConnection, this, [this]() {
        while (m_liveServer->hasPendingConnections()) {
            auto *socket = m_liveServer->nextPendingConnection();
            if (!socket) {
                continue;
            }

            socket->setProperty("wsBuffer", QByteArray());
            socket->setProperty("wsHandshakeDone", false);

            connect(socket, &QTcpSocket::readyRead, this, [this, socket]() {
                QByteArray buffer = socket->property("wsBuffer").toByteArray();
                buffer.append(socket->readAll());
                const bool handshakeDone = socket->property("wsHandshakeDone").toBool();
                if (!handshakeDone) {
                    const int separatorIndex = buffer.indexOf("\r\n\r\n");
                    if (separatorIndex < 0) {
                        socket->setProperty("wsBuffer", buffer);
                        return;
                    }

                    const QByteArray handshake = buffer.left(separatorIndex + 4);
                    socket->write(makeWebSocketHandshakeResponse(handshake));
                    socket->setProperty("wsHandshakeDone", true);
                    m_clients.append(socket);

                    const QByteArray bootstrap = QJsonDocument(QJsonObject{
                        {QStringLiteral("type"), QStringLiteral("bootstrap")},
                        {QStringLiteral("payload"), collectDashboardPayload()},
                    }).toJson(QJsonDocument::Compact);
                    socket->write(makeWebSocketFrame(bootstrap));
                    buffer.remove(0, separatorIndex + 4);
                }

                socket->setProperty("wsBuffer", buffer);
            });

            connect(socket, &QTcpSocket::disconnected, this, [this, socket]() {
                m_clients.removeAll(socket);
                socket->deleteLater();
            });
        }
    });
}

QJsonObject ApiServer::collectDashboardPayload() const
{
    return QJsonObject{
        {QStringLiteral("user"), toJson(m_database.user())},
        {QStringLiteral("activity"), toJson(m_database.latestActivity())},
        {QStringLiteral("weather"), toJson(m_database.latestWeather())},
        {QStringLiteral("deviceStatus"), toJson(m_database.deviceStatus())},
        {QStringLiteral("relaxExercises"), toJsonArray(m_database.relaxExercises())},
        {QStringLiteral("notifications"), toJsonArray(m_database.notifications())},
        {QStringLiteral("simulationRunning"), m_simulationRunning},
    };
}

QByteArray ApiServer::makeHttpResponse(const QJsonDocument &payload, int statusCode, const QByteArray &statusText) const
{
    const QByteArray body = payload.toJson(QJsonDocument::Compact);
    QByteArray response;
    response += "HTTP/1.1 " + QByteArray::number(statusCode) + " " + statusText + "\r\n";
    response += "Content-Type: application/json\r\n";
    response += "Content-Length: " + QByteArray::number(body.size()) + "\r\n";
    response += "Connection: close\r\n";
    response += "\r\n";
    response += body;
    return response;
}

QByteArray ApiServer::handleHttpRequest(const QByteArray &requestData)
{
    const int separatorIndex = requestData.indexOf("\r\n\r\n");
    if (separatorIndex < 0) {
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("error"), QStringLiteral("Malformed request")}}), 400, "Bad Request");
    }

    const QByteArray headersData = requestData.left(separatorIndex);
    const QByteArray bodyData = requestData.mid(separatorIndex + 4);
    const QList<QByteArray> headerLines = headersData.split('\n');
    if (headerLines.isEmpty()) {
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("error"), QStringLiteral("Missing request line")}}), 400, "Bad Request");
    }

    const QList<QByteArray> requestLineParts = headerLines.first().trimmed().split(' ');
    if (requestLineParts.size() < 2) {
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("error"), QStringLiteral("Invalid request line")}}), 400, "Bad Request");
    }

    const QByteArray method = requestLineParts.at(0);
    const QString path = QString::fromUtf8(requestLineParts.at(1));
    const QJsonObject body = bodyData.isEmpty() ? QJsonObject() : QJsonDocument::fromJson(bodyData).object();

    if (method == "GET" && path == QStringLiteral("/api/activity")) {
        return makeHttpResponse(QJsonDocument(QJsonObject{
            {QStringLiteral("user"), toJson(m_database.user())},
            {QStringLiteral("activity"), toJson(m_database.latestActivity())},
        }));
    }

    if (method == "POST" && path == QStringLiteral("/api/activity")) {
        ActivityRecord current = m_database.latestActivity();
        if (body.contains(QStringLiteral("steps"))) {
            current.steps = body.value(QStringLiteral("steps")).toInt(current.steps);
        }
        if (body.contains(QStringLiteral("calories"))) {
            current.calories = body.value(QStringLiteral("calories")).toInt(current.calories);
        }
        if (body.contains(QStringLiteral("goalProgressPercent"))) {
            current.goalProgressPercent = body.value(QStringLiteral("goalProgressPercent")).toInt(current.goalProgressPercent);
        }
        if (body.contains(QStringLiteral("heartRate"))) {
            current.heartRate = body.value(QStringLiteral("heartRate")).toInt(current.heartRate);
        }
        current.timestamp = QDateTime::currentDateTimeUtc();
        m_database.saveActivity(current);
        broadcastLivePayload(QJsonObject{
            {QStringLiteral("type"), QStringLiteral("liveUpdate")},
            {QStringLiteral("activity"), toJson(current)},
            {QStringLiteral("deviceStatus"), toJson(m_database.deviceStatus())},
            {QStringLiteral("running"), m_simulationRunning},
        });
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("ok"), true}, {QStringLiteral("activity"), toJson(current)}}));
    }

    if (method == "POST" && path == QStringLiteral("/api/activity/reset")) {
        m_database.resetActivity();
        QMetaObject::invokeMethod(m_simulator, "reset", Qt::QueuedConnection);
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("ok"), true}}));
    }

    if (method == "GET" && path == QStringLiteral("/api/weather")) {
        return makeHttpResponse(QJsonDocument(toJson(m_database.latestWeather())));
    }

    if (method == "GET" && path == QStringLiteral("/api/relax/exercises")) {
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("items"), toJsonArray(m_database.relaxExercises())}}));
    }

    if (method == "POST" && path.startsWith(QStringLiteral("/api/relax/complete/"))) {
        const int id = path.section('/', -1).toInt();
        m_database.completeExercise(id);
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("ok"), true}, {QStringLiteral("items"), toJsonArray(m_database.relaxExercises())}}));
    }

    if (method == "GET" && path == QStringLiteral("/api/notifications")) {
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("items"), toJsonArray(m_database.notifications())}}));
    }

    if (method == "GET" && path == QStringLiteral("/api/device/status")) {
        return makeHttpResponse(QJsonDocument(toJson(m_database.deviceStatus())));
    }

    if (method == "POST" && path == QStringLiteral("/api/simulation/start")) {
        m_simulationRunning = true;
        QMetaObject::invokeMethod(m_simulator, "start", Qt::QueuedConnection);
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("ok"), true}, {QStringLiteral("running"), true}}));
    }

    if (method == "POST" && path == QStringLiteral("/api/simulation/stop")) {
        m_simulationRunning = false;
        QMetaObject::invokeMethod(m_simulator, "stop", Qt::QueuedConnection);
        return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("ok"), true}, {QStringLiteral("running"), false}}));
    }

    if (method == "GET" && path == QStringLiteral("/api/dashboard")) {
        return makeHttpResponse(QJsonDocument(collectDashboardPayload()));
    }

    return makeHttpResponse(QJsonDocument(QJsonObject{{QStringLiteral("error"), QStringLiteral("Not found")}}), 404, "Not Found");
}

QByteArray ApiServer::makeWebSocketFrame(const QByteArray &payload) const
{
    QByteArray frame;
    frame.append(char(0x81));
    if (payload.size() <= 125) {
        frame.append(char(payload.size()));
    } else if (payload.size() <= 65535) {
        frame.append(char(126));
        frame.append(char((payload.size() >> 8) & 0xFF));
        frame.append(char(payload.size() & 0xFF));
    } else {
        frame.append(char(127));
        for (int shift = 56; shift >= 0; shift -= 8) {
            frame.append(char((static_cast<quint64>(payload.size()) >> shift) & 0xFF));
        }
    }
    frame.append(payload);
    return frame;
}

QByteArray ApiServer::makeWebSocketHandshakeResponse(const QByteArray &requestData) const
{
    QByteArray key;
    const QList<QByteArray> lines = requestData.split('\n');
    for (const QByteArray &line : lines) {
        const QByteArray trimmed = line.trimmed();
        if (trimmed.toLower().startsWith("sec-websocket-key:")) {
            key = trimmed.mid(QByteArray("sec-websocket-key:").size()).trimmed();
            break;
        }
    }

    const QByteArray acceptSeed = key + QByteArrayLiteral("258EAFA5-E914-47DA-95CA-C5AB0DC85B11");
    const QByteArray accept = QCryptographicHash::hash(acceptSeed, QCryptographicHash::Sha1).toBase64();

    QByteArray response;
    response += "HTTP/1.1 101 Switching Protocols\r\n";
    response += "Upgrade: websocket\r\n";
    response += "Connection: Upgrade\r\n";
    response += "Sec-WebSocket-Accept: " + accept + "\r\n";
    response += "\r\n";
    return response;
}

void ApiServer::handleHttpConnection()
{
    while (m_tcpServer->hasPendingConnections()) {
        auto *socket = m_tcpServer->nextPendingConnection();
        if (!socket) {
            continue;
        }

        auto *buffer = new QByteArray();
        connect(socket, &QTcpSocket::readyRead, this, [this, socket, buffer]() {
            buffer->append(socket->readAll());
            const int separatorIndex = buffer->indexOf("\r\n\r\n");
            if (separatorIndex < 0) {
                return;
            }

            const QByteArray headers = buffer->left(separatorIndex);
            qsizetype contentLength = 0;
            for (const QByteArray &line : headers.split('\n')) {
                const QByteArray trimmed = line.trimmed();
                if (trimmed.toLower().startsWith("content-length:")) {
                    contentLength = trimmed.mid(QByteArray("content-length:").size()).trimmed().toLongLong();
                }
            }

            const qsizetype bodySize = buffer->size() - (separatorIndex + 4);
            if (bodySize < contentLength) {
                return;
            }

            socket->write(handleHttpRequest(*buffer));
            socket->disconnectFromHost();
        });

        connect(socket, &QTcpSocket::disconnected, this, [socket, buffer]() {
            delete buffer;
            socket->deleteLater();
        });
    }
}

ActivityRecord ApiServer::activityFromJson(const QJsonObject &json) const
{
    ActivityRecord record;
    record.timestamp = QDateTime::fromString(json.value(QStringLiteral("timestamp")).toString(), Qt::ISODate);
    record.steps = json.value(QStringLiteral("steps")).toInt();
    record.calories = json.value(QStringLiteral("calories")).toInt();
    record.goalProgressPercent = json.value(QStringLiteral("goalProgressPercent")).toInt();
    record.heartRate = json.value(QStringLiteral("heartRate")).toInt();
    return record;
}

DeviceStatus ApiServer::deviceStatusFromJson(const QJsonObject &json) const
{
    DeviceStatus status;
    status.batteryLevel = json.value(QStringLiteral("batteryLevel")).toInt();
    status.currentTime = QDateTime::fromString(json.value(QStringLiteral("currentTime")).toString(), Qt::ISODate);
    status.connectionStatus = json.value(QStringLiteral("connectionStatus")).toString();
    return status;
}
