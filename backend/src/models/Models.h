#pragma once

#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>
#include <QString>

struct User {
    int id = 1;
    QString name;
    QString avatarPlaceholder;
    int dailyStepGoal = 8000;
};

struct ActivityRecord {
    QDateTime timestamp;
    int steps = 0;
    int calories = 0;
    int goalProgressPercent = 0;
    int heartRate = 72;
};

struct WeatherData {
    QDateTime timestamp;
    double currentTemp = 0.0;
    QString currentDescription;
    double tomorrowMin = 0.0;
    double tomorrowMax = 0.0;
    QString tomorrowDescription;
};

struct RelaxExercise {
    int id = 0;
    QString name;
    int durationSeconds = 0;
    bool completed = false;
    QDateTime completedAt;
};

struct NotificationItem {
    int id = 0;
    QString message;
    QDateTime triggeredAt;
    QString type;
};

struct DeviceStatus {
    int batteryLevel = 100;
    QDateTime currentTime;
    QString connectionStatus = QStringLiteral("connected");
};

QJsonObject toJson(const User &user);
QJsonObject toJson(const ActivityRecord &record);
QJsonObject toJson(const WeatherData &weather);
QJsonObject toJson(const RelaxExercise &exercise);
QJsonObject toJson(const NotificationItem &notification);
QJsonObject toJson(const DeviceStatus &status);
QJsonArray toJsonArray(const QList<RelaxExercise> &exercises);
QJsonArray toJsonArray(const QList<NotificationItem> &notifications);
