#pragma once

#include "models/Models.h"

#include <QObject>
#include <QSqlDatabase>

class Database : public QObject
{
    Q_OBJECT

public:
    explicit Database(QObject *parent = nullptr);

    bool initialize();

    User user() const;
    ActivityRecord latestActivity() const;
    WeatherData latestWeather() const;
    QList<RelaxExercise> relaxExercises() const;
    QList<NotificationItem> notifications() const;
    DeviceStatus deviceStatus() const;

    bool upsertUser(const User &user);
    bool saveActivity(const ActivityRecord &record);
    bool saveWeather(const WeatherData &weather);
    bool completeExercise(int id);
    bool addNotification(const QString &message, const QString &type, const QDateTime &triggeredAt);
    bool saveDeviceStatus(const DeviceStatus &status);
    bool resetActivity();

private:
    bool createTables();
    bool seedDefaults();
    QString databasePath() const;
    mutable QSqlDatabase m_db;
};
