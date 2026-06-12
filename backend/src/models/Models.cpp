#include "Models.h"

namespace {
QString isoString(const QDateTime &value)
{
    return value.isValid() ? value.toUTC().toString(Qt::ISODate) : QString();
}
}

QJsonObject toJson(const User &user)
{
    return {
        {QStringLiteral("id"), user.id},
        {QStringLiteral("name"), user.name},
        {QStringLiteral("avatarPlaceholder"), user.avatarPlaceholder},
        {QStringLiteral("dailyStepGoal"), user.dailyStepGoal},
    };
}

QJsonObject toJson(const ActivityRecord &record)
{
    return {
        {QStringLiteral("timestamp"), isoString(record.timestamp)},
        {QStringLiteral("steps"), record.steps},
        {QStringLiteral("calories"), record.calories},
        {QStringLiteral("goalProgressPercent"), record.goalProgressPercent},
        {QStringLiteral("heartRate"), record.heartRate},
    };
}

QJsonObject toJson(const WeatherData &weather)
{
    return {
        {QStringLiteral("timestamp"), isoString(weather.timestamp)},
        {QStringLiteral("currentTemp"), weather.currentTemp},
        {QStringLiteral("currentDescription"), weather.currentDescription},
        {QStringLiteral("tomorrowMin"), weather.tomorrowMin},
        {QStringLiteral("tomorrowMax"), weather.tomorrowMax},
        {QStringLiteral("tomorrowDescription"), weather.tomorrowDescription},
    };
}

QJsonObject toJson(const RelaxExercise &exercise)
{
    return {
        {QStringLiteral("id"), exercise.id},
        {QStringLiteral("name"), exercise.name},
        {QStringLiteral("durationSeconds"), exercise.durationSeconds},
        {QStringLiteral("completed"), exercise.completed},
        {QStringLiteral("completedAt"), isoString(exercise.completedAt)},
    };
}

QJsonObject toJson(const NotificationItem &notification)
{
    return {
        {QStringLiteral("id"), notification.id},
        {QStringLiteral("message"), notification.message},
        {QStringLiteral("triggeredAt"), isoString(notification.triggeredAt)},
        {QStringLiteral("type"), notification.type},
    };
}

QJsonObject toJson(const DeviceStatus &status)
{
    return {
        {QStringLiteral("batteryLevel"), status.batteryLevel},
        {QStringLiteral("currentTime"), isoString(status.currentTime)},
        {QStringLiteral("connectionStatus"), status.connectionStatus},
    };
}

QJsonArray toJsonArray(const QList<RelaxExercise> &exercises)
{
    QJsonArray array;
    for (const auto &exercise : exercises) {
        array.append(toJson(exercise));
    }
    return array;
}

QJsonArray toJsonArray(const QList<NotificationItem> &notifications)
{
    QJsonArray array;
    for (const auto &notification : notifications) {
        array.append(toJson(notification));
    }
    return array;
}
