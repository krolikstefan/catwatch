#pragma once

#include "models/Models.h"

#include <QObject>
#include <QSet>
#include <QStringList>

class SensorSimulator : public QObject
{
    Q_OBJECT

public:
    SensorSimulator(const User &user, const ActivityRecord &activity, const DeviceStatus &deviceStatus, QObject *parent = nullptr);

signals:
    void liveDataReady(const QJsonObject &payload);

public slots:
    void start();
    void stop();
    void reset();

private slots:
    void tick();

private:
    int stepsForHour(int hour) const;
    int nextHeartRate() const;
    void emitCurrentSnapshot();

    class QTimer *m_timer = nullptr;
    bool m_running = false;
    User m_user;
    ActivityRecord m_activity;
    DeviceStatus m_deviceStatus;
    QDateTime m_simulatedTime;
    double m_simulatedSecondsRemainder = 0.0;
    int m_dayDurationSeconds = 300;
    QSet<int> m_goalNotificationThresholds;
};
