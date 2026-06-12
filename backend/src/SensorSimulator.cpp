#include "SensorSimulator.h"

#include <QJsonArray>
#include <QJsonObject>
#include <QRandomGenerator>
#include <QSettings>
#include <QTimer>

SensorSimulator::SensorSimulator(const User &user, const ActivityRecord &activity, const DeviceStatus &deviceStatus, QObject *parent)
    : QObject(parent)
    , m_user(user)
    , m_activity(activity)
    , m_deviceStatus(deviceStatus)
{
    QSettings settings;
    m_dayDurationSeconds = settings.value(QStringLiteral("simulation/dayDurationSeconds"), 300).toInt();
    m_simulatedTime = m_activity.timestamp.isValid() ? m_activity.timestamp : QDateTime::currentDateTimeUtc();
    if (!m_deviceStatus.currentTime.isValid()) {
        m_deviceStatus.currentTime = m_simulatedTime;
    }

    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &SensorSimulator::tick);
}

void SensorSimulator::start()
{
    if (m_running) {
        return;
    }
    m_running = true;
    m_timer->start();
    emitCurrentSnapshot();
}

void SensorSimulator::stop()
{
    m_running = false;
    m_timer->stop();
    emitCurrentSnapshot();
}

void SensorSimulator::reset()
{
    m_goalNotificationThresholds.clear();
    m_simulatedTime = QDateTime::currentDateTimeUtc();
    m_simulatedSecondsRemainder = 0.0;
    m_activity = ActivityRecord{};
    m_activity.timestamp = m_simulatedTime;
    m_deviceStatus.batteryLevel = 100;
    m_deviceStatus.currentTime = m_simulatedTime;
    m_deviceStatus.connectionStatus = QStringLiteral("connected");
    emitCurrentSnapshot();
}

void SensorSimulator::tick()
{
    if (!m_running) {
        return;
    }

    m_simulatedSecondsRemainder += 86400.0 / qMax(1, m_dayDurationSeconds);
    const int fullSeconds = static_cast<int>(m_simulatedSecondsRemainder);
    m_simulatedSecondsRemainder -= fullSeconds;
    m_simulatedTime = m_simulatedTime.addSecs(fullSeconds);

    const int stepsIncrement = stepsForHour(m_simulatedTime.time().hour());
    m_activity.timestamp = m_simulatedTime;
    m_activity.steps += stepsIncrement;
    m_activity.calories = qRound(m_activity.steps * 0.04);
    m_activity.goalProgressPercent = qMin(100, qRound((m_activity.steps * 100.0) / qMax(1, m_user.dailyStepGoal)));
    m_activity.heartRate = nextHeartRate();

    m_deviceStatus.batteryLevel = qMax(5, m_deviceStatus.batteryLevel - QRandomGenerator::global()->bounded(0, 2));
    m_deviceStatus.currentTime = m_simulatedTime;
    m_deviceStatus.connectionStatus = QStringLiteral("connected");

    QJsonArray milestones;

    for (const int threshold : {75, 100}) {
        if (m_activity.goalProgressPercent >= threshold && !m_goalNotificationThresholds.contains(threshold)) {
            m_goalNotificationThresholds.insert(threshold);
            milestones.append(QJsonObject{
                {QStringLiteral("threshold"), threshold},
                {QStringLiteral("message"), threshold == 100
                ? QStringLiteral("Brawo! Cel kroków wykonany.")
                : QStringLiteral("Już %1% celu kroków. Tak trzymaj!").arg(threshold)}
            });
        }
    }

    emit liveDataReady(QJsonObject{
        {QStringLiteral("type"), QStringLiteral("liveUpdate")},
        {QStringLiteral("activity"), toJson(m_activity)},
        {QStringLiteral("deviceStatus"), toJson(m_deviceStatus)},
        {QStringLiteral("running"), m_running},
        {QStringLiteral("milestones"), milestones},
    });
}

int SensorSimulator::stepsForHour(int hour) const
{
    int base = 2;
    if (hour >= 7 && hour < 9) {
        base = 24;
    } else if (hour >= 9 && hour < 14) {
        base = 18;
    } else if (hour >= 14 && hour < 19) {
        base = 28;
    } else if (hour >= 19 && hour < 21) {
        base = 10;
    }

    return base + QRandomGenerator::global()->bounded(0, 8);
}

int SensorSimulator::nextHeartRate() const
{
    return 60 + QRandomGenerator::global()->bounded(61);
}

void SensorSimulator::emitCurrentSnapshot()
{
    emit liveDataReady(QJsonObject{
        {QStringLiteral("type"), QStringLiteral("liveUpdate")},
        {QStringLiteral("activity"), toJson(m_activity)},
        {QStringLiteral("deviceStatus"), toJson(m_deviceStatus)},
        {QStringLiteral("running"), m_running},
    });
}
