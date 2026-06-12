#include "ApiClient.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTcpSocket>
#include <QTimer>
#include <QVariantMap>

ApiClient::ApiClient(QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_webSocket(new QTcpSocket(this))
    , m_pollTimer(new QTimer(this))
    , m_baseUrl(qEnvironmentVariable("KOTEKWATCH_API_BASE_URL", "http://127.0.0.1:8080"))
    , m_webSocketUrl(qEnvironmentVariable("KOTEKWATCH_WS_URL", "ws://127.0.0.1:8081/ws"))
{
    connect(m_webSocket, &QTcpSocket::connected, this, [this]() {
        m_webSocketHandshakeDone = false;
        m_webSocketBuffer.clear();
        m_webSocket->write(createWebSocketHandshake());
    });

    connect(m_webSocket, &QTcpSocket::readyRead, this, [this]() {
        m_webSocketBuffer.append(m_webSocket->readAll());
        processWebSocketBuffer();
    });

    connect(m_webSocket, &QTcpSocket::disconnected, this, [this]() {
        m_webSocketHandshakeDone = false;
        m_webSocketBuffer.clear();
        QTimer::singleShot(2000, this, [this]() {
            connectWebSocket();
        });
    });

    connect(m_pollTimer, &QTimer::timeout, this, &ApiClient::refreshAll);
    m_pollTimer->setInterval(15000);
    m_pollTimer->start();

    connectWebSocket();
    refreshAll();
}

void ApiClient::refreshAll()
{
    get(QStringLiteral("/api/dashboard"), [this](const QJsonDocument &document) {
        handleDashboardPayload(document.object());
    });
}

void ApiClient::startSimulation()
{
    post(QStringLiteral("/api/simulation/start"), QJsonObject(), [this](const QJsonDocument &document) {
        const bool running = document.object().value(QStringLiteral("running")).toBool(true);
        if (m_simulationRunning != running) {
            m_simulationRunning = running;
            emit simulationRunningChanged();
        }
    });
}

void ApiClient::stopSimulation()
{
    post(QStringLiteral("/api/simulation/stop"), QJsonObject(), [this](const QJsonDocument &document) {
        const bool running = document.object().value(QStringLiteral("running")).toBool(false);
        if (m_simulationRunning != running) {
            m_simulationRunning = running;
            emit simulationRunningChanged();
        }
    });
}

void ApiClient::resetActivity()
{
    post(QStringLiteral("/api/activity/reset"), QJsonObject(), [this](const QJsonDocument &) {
        refreshAll();
    });
}

void ApiClient::completeExercise(int id)
{
    post(QStringLiteral("/api/relax/complete/%1").arg(id), QJsonObject(), [this](const QJsonDocument &document) {
        const QVariantList nextExercises = parseExerciseList(document.object().value(QStringLiteral("items")).toArray());
        if (m_exercises != nextExercises) {
            m_exercises = nextExercises;
            emit relaxChanged();
        }
        updateRelaxStatus();
    });
}

void ApiClient::get(const QString &path, const std::function<void(const QJsonDocument &)> &handler)
{
    auto *reply = m_networkManager->get(QNetworkRequest(m_baseUrl.resolved(QUrl(path))));
    connect(reply, &QNetworkReply::finished, this, [reply, handler]() {
        const QJsonDocument document = QJsonDocument::fromJson(reply->readAll());
        if (handler) {
            handler(document);
        }
        reply->deleteLater();
    });
}

void ApiClient::post(const QString &path, const QJsonObject &body, const std::function<void(const QJsonDocument &)> &handler)
{
    QNetworkRequest request(m_baseUrl.resolved(QUrl(path)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
    auto *reply = m_networkManager->post(request, QJsonDocument(body).toJson(QJsonDocument::Compact));
    connect(reply, &QNetworkReply::finished, this, [reply, handler]() {
        const QJsonDocument document = QJsonDocument::fromJson(reply->readAll());
        if (handler) {
            handler(document);
        }
        reply->deleteLater();
    });
}

void ApiClient::handleDashboardPayload(const QJsonObject &payload)
{
    if (payload.contains(QStringLiteral("activity"))) {
        const QJsonObject activity = payload.value(QStringLiteral("activity")).toObject();
        const int steps = activity.value(QStringLiteral("steps")).toInt();
        const int calories = activity.value(QStringLiteral("calories")).toInt();
        const int goalPercent = activity.value(QStringLiteral("goalProgressPercent")).toInt();
        const int heartRate = activity.value(QStringLiteral("heartRate")).toInt();
        if (steps != m_steps || calories != m_calories || goalPercent != m_goalPercent || heartRate != m_heartRate) {
            m_steps = steps;
            m_calories = calories;
            m_goalPercent = goalPercent;
            m_heartRate = heartRate;
            emit activityChanged();
        }
    }

    if (payload.contains(QStringLiteral("deviceStatus"))) {
        const QJsonObject device = payload.value(QStringLiteral("deviceStatus")).toObject();
        const int battery = device.value(QStringLiteral("batteryLevel")).toInt();
        if (battery != m_battery) {
            m_battery = battery;
            emit deviceChanged();
        }
    }

    if (payload.contains(QStringLiteral("weather"))) {
        const QJsonObject weather = payload.value(QStringLiteral("weather")).toObject();
        const double temperature = weather.value(QStringLiteral("currentTemp")).toDouble();
        const QString description = weather.value(QStringLiteral("currentDescription")).toString();
        const QString tomorrow = QStringLiteral("%1°C / %2°C - %3")
            .arg(weather.value(QStringLiteral("tomorrowMin")).toDouble(), 0, 'f', 1)
            .arg(weather.value(QStringLiteral("tomorrowMax")).toDouble(), 0, 'f', 1)
            .arg(weather.value(QStringLiteral("tomorrowDescription")).toString());
        if (!qFuzzyCompare(temperature + 1.0, m_temperature + 1.0)
            || description != m_weatherDescription
            || tomorrow != m_tomorrowForecast) {
            m_temperature = temperature;
            m_weatherDescription = description;
            m_tomorrowForecast = tomorrow;
            emit weatherChanged();
        }
    }

    if (payload.contains(QStringLiteral("relaxExercises"))) {
        const QVariantList nextExercises = parseExerciseList(payload.value(QStringLiteral("relaxExercises")).toArray());
        if (nextExercises != m_exercises) {
            m_exercises = nextExercises;
            emit relaxChanged();
        }
        updateRelaxStatus();
    }

    if (payload.contains(QStringLiteral("notifications"))) {
        const QVariantList nextNotifications = parseNotificationList(payload.value(QStringLiteral("notifications")).toArray());
        if (nextNotifications != m_notifications) {
            m_notifications = nextNotifications;
            emit notificationsChanged();
        }
    }

    if (payload.contains(QStringLiteral("simulationRunning"))) {
        const bool running = payload.value(QStringLiteral("simulationRunning")).toBool(m_simulationRunning);
        if (running != m_simulationRunning) {
            m_simulationRunning = running;
            emit simulationRunningChanged();
        }
    }
}

void ApiClient::connectWebSocket()
{
    m_webSocket->connectToHost(m_webSocketUrl.host(), static_cast<quint16>(m_webSocketUrl.port()));
}

void ApiClient::processWebSocketBuffer()
{
    if (!m_webSocketHandshakeDone) {
        const int separatorIndex = m_webSocketBuffer.indexOf("\r\n\r\n");
        if (separatorIndex < 0) {
            return;
        }

        m_webSocketHandshakeDone = true;
        m_webSocketBuffer.remove(0, separatorIndex + 4);
    }

    while (m_webSocketBuffer.size() >= 2) {
        const quint8 byte1 = static_cast<quint8>(m_webSocketBuffer.at(0));
        const quint8 byte2 = static_cast<quint8>(m_webSocketBuffer.at(1));
        if ((byte1 & 0x0F) != 0x1) {
            return;
        }

        quint64 payloadLength = byte2 & 0x7F;
        int offset = 2;
        if (payloadLength == 126) {
            if (m_webSocketBuffer.size() < 4) {
                return;
            }
            payloadLength = (static_cast<quint8>(m_webSocketBuffer.at(2)) << 8)
                | static_cast<quint8>(m_webSocketBuffer.at(3));
            offset = 4;
        } else if (payloadLength == 127) {
            if (m_webSocketBuffer.size() < 10) {
                return;
            }
            payloadLength = 0;
            for (int index = 2; index < 10; ++index) {
                payloadLength = (payloadLength << 8) | static_cast<quint8>(m_webSocketBuffer.at(index));
            }
            offset = 10;
        }

        if (m_webSocketBuffer.size() < offset + static_cast<int>(payloadLength)) {
            return;
        }

        const QByteArray payload = m_webSocketBuffer.mid(offset, payloadLength);
        m_webSocketBuffer.remove(0, offset + payloadLength);

        const QJsonObject root = QJsonDocument::fromJson(payload).object();
        const QString type = root.value(QStringLiteral("type")).toString();
        if (type == QStringLiteral("bootstrap")) {
            handleDashboardPayload(root.value(QStringLiteral("payload")).toObject());
            continue;
        }

        if (type == QStringLiteral("liveUpdate")) {
            handleDashboardPayload(QJsonObject{
                {QStringLiteral("activity"), root.value(QStringLiteral("activity")).toObject()},
                {QStringLiteral("deviceStatus"), root.value(QStringLiteral("deviceStatus")).toObject()},
            });
            const bool running = root.value(QStringLiteral("running")).toBool(m_simulationRunning);
            if (running != m_simulationRunning) {
                m_simulationRunning = running;
                emit simulationRunningChanged();
            }
        }
    }
}

QByteArray ApiClient::createWebSocketHandshake() const
{
    QByteArray request;
    request += "GET " + m_webSocketUrl.path().toUtf8() + " HTTP/1.1\r\n";
    request += "Host: " + m_webSocketUrl.host().toUtf8() + ":" + QByteArray::number(m_webSocketUrl.port()) + "\r\n";
    request += "Upgrade: websocket\r\n";
    request += "Connection: Upgrade\r\n";
    request += "Sec-WebSocket-Version: 13\r\n";
    request += "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n";
    request += "\r\n";
    return request;
}

QVariantList ApiClient::parseExerciseList(const QJsonArray &array) const
{
    QVariantList result;
    for (const auto &entry : array) {
        const QJsonObject object = entry.toObject();
        QVariantMap item;
        item.insert(QStringLiteral("id"), object.value(QStringLiteral("id")).toInt());
        item.insert(QStringLiteral("name"), object.value(QStringLiteral("name")).toString());
        item.insert(QStringLiteral("durationSeconds"), object.value(QStringLiteral("durationSeconds")).toInt());
        item.insert(QStringLiteral("completed"), object.value(QStringLiteral("completed")).toBool());
        item.insert(QStringLiteral("completedAt"), object.value(QStringLiteral("completedAt")).toString());
        result.append(item);
    }
    return result;
}

QVariantList ApiClient::parseNotificationList(const QJsonArray &array) const
{
    QVariantList result;
    for (const auto &entry : array) {
        const QJsonObject object = entry.toObject();
        QVariantMap item;
        item.insert(QStringLiteral("id"), object.value(QStringLiteral("id")).toInt());
        item.insert(QStringLiteral("message"), object.value(QStringLiteral("message")).toString());
        item.insert(QStringLiteral("triggeredAt"), object.value(QStringLiteral("triggeredAt")).toString());
        item.insert(QStringLiteral("type"), object.value(QStringLiteral("type")).toString());
        result.append(item);
    }
    return result;
}

void ApiClient::updateRelaxStatus()
{
    int completed = 0;
    for (const auto &entry : m_exercises) {
        if (entry.toMap().value(QStringLiteral("completed")).toBool()) {
            ++completed;
        }
    }

    const QString nextStatus = QStringLiteral("%1 / %2 ukończone").arg(completed).arg(m_exercises.size());
    if (nextStatus != m_relaxStatus) {
        m_relaxStatus = nextStatus;
        emit relaxChanged();
    }
}
