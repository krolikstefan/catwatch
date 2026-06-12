#pragma once

#include <QObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QVariantList>
#include <functional>

class QNetworkAccessManager;
class QNetworkReply;
class QTcpSocket;
class QTimer;

class ApiClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int steps READ steps NOTIFY activityChanged)
    Q_PROPERTY(int calories READ calories NOTIFY activityChanged)
    Q_PROPERTY(int goalPercent READ goalPercent NOTIFY activityChanged)
    Q_PROPERTY(int heartRate READ heartRate NOTIFY activityChanged)
    Q_PROPERTY(int battery READ battery NOTIFY deviceChanged)
    Q_PROPERTY(double temperature READ temperature NOTIFY weatherChanged)
    Q_PROPERTY(QString weatherDescription READ weatherDescription NOTIFY weatherChanged)
    Q_PROPERTY(QString tomorrowForecast READ tomorrowForecast NOTIFY weatherChanged)
    Q_PROPERTY(QString relaxStatus READ relaxStatus NOTIFY relaxChanged)
    Q_PROPERTY(QVariantList exercises READ exercises NOTIFY relaxChanged)
    Q_PROPERTY(QVariantList notifications READ notifications NOTIFY notificationsChanged)
    Q_PROPERTY(bool simulationRunning READ simulationRunning NOTIFY simulationRunningChanged)

public:
    explicit ApiClient(QObject *parent = nullptr);

    int steps() const { return m_steps; }
    int calories() const { return m_calories; }
    int goalPercent() const { return m_goalPercent; }
    int heartRate() const { return m_heartRate; }
    int battery() const { return m_battery; }
    double temperature() const { return m_temperature; }
    QString weatherDescription() const { return m_weatherDescription; }
    QString tomorrowForecast() const { return m_tomorrowForecast; }
    QString relaxStatus() const { return m_relaxStatus; }
    QVariantList exercises() const { return m_exercises; }
    QVariantList notifications() const { return m_notifications; }
    bool simulationRunning() const { return m_simulationRunning; }

    Q_INVOKABLE void refreshAll();
    Q_INVOKABLE void startSimulation();
    Q_INVOKABLE void stopSimulation();
    Q_INVOKABLE void resetActivity();
    Q_INVOKABLE void completeExercise(int id);

signals:
    void activityChanged();
    void deviceChanged();
    void weatherChanged();
    void relaxChanged();
    void notificationsChanged();
    void simulationRunningChanged();

private:
    void get(const QString &path, const std::function<void(const QJsonDocument &)> &handler);
    void post(const QString &path, const QJsonObject &body, const std::function<void(const QJsonDocument &)> &handler = {});
    void handleDashboardPayload(const QJsonObject &payload);
    void connectWebSocket();
    void processWebSocketBuffer();
    QByteArray createWebSocketHandshake() const;
    QVariantList parseExerciseList(const QJsonArray &array) const;
    QVariantList parseNotificationList(const QJsonArray &array) const;
    void updateRelaxStatus();

    QNetworkAccessManager *m_networkManager = nullptr;
    QTcpSocket *m_webSocket = nullptr;
    QTimer *m_pollTimer = nullptr;
    QUrl m_baseUrl;
    QUrl m_webSocketUrl;
    QByteArray m_webSocketBuffer;
    bool m_webSocketHandshakeDone = false;
    int m_steps = 0;
    int m_calories = 0;
    int m_goalPercent = 0;
    int m_heartRate = 0;
    int m_battery = 100;
    double m_temperature = 0.0;
    QString m_weatherDescription;
    QString m_tomorrowForecast;
    QString m_relaxStatus;
    QVariantList m_exercises;
    QVariantList m_notifications;
    bool m_simulationRunning = false;
};
