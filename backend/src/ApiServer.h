#pragma once

#include "Database.h"
#include "SensorSimulator.h"

#include <QObject>
#include <QJsonDocument>
#include <QPointer>
#include <QJsonArray>
#include <QJsonObject>

class QNetworkAccessManager;
class QNetworkReply;
class QThread;
class QTcpServer;
class QTcpSocket;

class ApiServer : public QObject
{
    Q_OBJECT

public:
    explicit ApiServer(QObject *parent = nullptr);
    ~ApiServer() override;

    bool start(quint16 httpPort = 8080, quint16 wsPort = 8081);

private slots:
    void broadcastLivePayload(const QJsonObject &payload);
    void fetchWeather();
    void handleWeatherReply(QNetworkReply *reply);
    void handleHttpConnection();

private:
    void setupHttpServer(quint16 port);
    void setupLiveSocketServer(quint16 port);
    QJsonObject collectDashboardPayload() const;
    QByteArray makeHttpResponse(const QJsonDocument &payload, int statusCode = 200, const QByteArray &statusText = "OK") const;
    QByteArray handleHttpRequest(const QByteArray &requestData);
    QByteArray makeWebSocketFrame(const QByteArray &payload) const;
    QByteArray makeWebSocketHandshakeResponse(const QByteArray &requestData) const;
    ActivityRecord activityFromJson(const QJsonObject &json) const;
    DeviceStatus deviceStatusFromJson(const QJsonObject &json) const;

    Database m_database;
    QTcpServer *m_tcpServer = nullptr;
    QTcpServer *m_liveServer = nullptr;
    QList<QPointer<QTcpSocket>> m_clients;
    SensorSimulator *m_simulator = nullptr;
    QThread *m_simulationThread = nullptr;
    QNetworkAccessManager *m_networkManager = nullptr;
    bool m_simulationRunning = false;
};
