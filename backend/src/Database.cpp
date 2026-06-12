#include "Database.h"

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariant>

namespace {
QString connectionName()
{
    return QStringLiteral("kotekwatch_connection");
}

QDateTime parseDateTime(const QVariant &value)
{
    return QDateTime::fromString(value.toString(), Qt::ISODate);
}
}

Database::Database(QObject *parent)
    : QObject(parent)
{
}

bool Database::initialize()
{
    if (QSqlDatabase::contains(connectionName())) {
        m_db = QSqlDatabase::database(connectionName());
    } else {
        m_db = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"), connectionName());
        m_db.setDatabaseName(databasePath());
    }

    if (!m_db.open()) {
        qWarning() << "Cannot open SQLite database" << m_db.lastError();
        return false;
    }

    return createTables() && seedDefaults();
}

User Database::user() const
{
    User result;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral("SELECT id, name, avatar_placeholder, daily_step_goal FROM users LIMIT 1"));
    if (query.exec() && query.next()) {
        result.id = query.value(0).toInt();
        result.name = query.value(1).toString();
        result.avatarPlaceholder = query.value(2).toString();
        result.dailyStepGoal = query.value(3).toInt();
    }
    return result;
}

ActivityRecord Database::latestActivity() const
{
    ActivityRecord result;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT timestamp, steps, calories, goal_progress_percent, heart_rate "
        "FROM activity_records ORDER BY timestamp DESC LIMIT 1"));
    if (query.exec() && query.next()) {
        result.timestamp = parseDateTime(query.value(0));
        result.steps = query.value(1).toInt();
        result.calories = query.value(2).toInt();
        result.goalProgressPercent = query.value(3).toInt();
        result.heartRate = query.value(4).toInt();
    }
    return result;
}

WeatherData Database::latestWeather() const
{
    WeatherData result;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT timestamp, current_temp, current_description, tomorrow_min, tomorrow_max, tomorrow_description "
        "FROM weather_cache ORDER BY timestamp DESC LIMIT 1"));
    if (query.exec() && query.next()) {
        result.timestamp = parseDateTime(query.value(0));
        result.currentTemp = query.value(1).toDouble();
        result.currentDescription = query.value(2).toString();
        result.tomorrowMin = query.value(3).toDouble();
        result.tomorrowMax = query.value(4).toDouble();
        result.tomorrowDescription = query.value(5).toString();
    }
    return result;
}

QList<RelaxExercise> Database::relaxExercises() const
{
    QList<RelaxExercise> items;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT id, name, duration_seconds, completed, completed_at "
        "FROM relax_exercises ORDER BY id ASC"));
    if (query.exec()) {
        while (query.next()) {
            RelaxExercise item;
            item.id = query.value(0).toInt();
            item.name = query.value(1).toString();
            item.durationSeconds = query.value(2).toInt();
            item.completed = query.value(3).toInt() != 0;
            item.completedAt = parseDateTime(query.value(4));
            items.append(item);
        }
    }
    return items;
}

QList<NotificationItem> Database::notifications() const
{
    QList<NotificationItem> items;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT id, message, triggered_at, type "
        "FROM notifications ORDER BY triggered_at DESC, id DESC LIMIT 50"));
    if (query.exec()) {
        while (query.next()) {
            NotificationItem item;
            item.id = query.value(0).toInt();
            item.message = query.value(1).toString();
            item.triggeredAt = parseDateTime(query.value(2));
            item.type = query.value(3).toString();
            items.append(item);
        }
    }
    return items;
}

DeviceStatus Database::deviceStatus() const
{
    DeviceStatus result;
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT battery_level, current_time, connection_status FROM device_status LIMIT 1"));
    if (query.exec() && query.next()) {
        result.batteryLevel = query.value(0).toInt();
        result.currentTime = parseDateTime(query.value(1));
        result.connectionStatus = query.value(2).toString();
    }
    return result;
}

bool Database::upsertUser(const User &user)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO users (id, name, avatar_placeholder, daily_step_goal) "
        "VALUES (?, ?, ?, ?) "
        "ON CONFLICT(id) DO UPDATE SET name=excluded.name, avatar_placeholder=excluded.avatar_placeholder, daily_step_goal=excluded.daily_step_goal"));
    query.addBindValue(user.id);
    query.addBindValue(user.name);
    query.addBindValue(user.avatarPlaceholder);
    query.addBindValue(user.dailyStepGoal);
    return query.exec();
}

bool Database::saveActivity(const ActivityRecord &record)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO activity_records (timestamp, steps, calories, goal_progress_percent, heart_rate) "
        "VALUES (?, ?, ?, ?, ?)"));
    query.addBindValue(record.timestamp.toUTC().toString(Qt::ISODate));
    query.addBindValue(record.steps);
    query.addBindValue(record.calories);
    query.addBindValue(record.goalProgressPercent);
    query.addBindValue(record.heartRate);
    return query.exec();
}

bool Database::saveWeather(const WeatherData &weather)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO weather_cache (timestamp, current_temp, current_description, tomorrow_min, tomorrow_max, tomorrow_description) "
        "VALUES (?, ?, ?, ?, ?, ?)"));
    query.addBindValue(weather.timestamp.toUTC().toString(Qt::ISODate));
    query.addBindValue(weather.currentTemp);
    query.addBindValue(weather.currentDescription);
    query.addBindValue(weather.tomorrowMin);
    query.addBindValue(weather.tomorrowMax);
    query.addBindValue(weather.tomorrowDescription);
    return query.exec();
}

bool Database::completeExercise(int id)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "UPDATE relax_exercises SET completed = 1, completed_at = ? WHERE id = ?"));
    query.addBindValue(QDateTime::currentDateTimeUtc().toString(Qt::ISODate));
    query.addBindValue(id);
    return query.exec();
}

bool Database::addNotification(const QString &message, const QString &type, const QDateTime &triggeredAt)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO notifications (message, triggered_at, type) VALUES (?, ?, ?)"));
    query.addBindValue(message);
    query.addBindValue(triggeredAt.toUTC().toString(Qt::ISODate));
    query.addBindValue(type);
    return query.exec();
}

bool Database::saveDeviceStatus(const DeviceStatus &status)
{
    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO device_status (id, battery_level, current_time, connection_status) "
        "VALUES (1, ?, ?, ?) "
        "ON CONFLICT(id) DO UPDATE SET battery_level=excluded.battery_level, current_time=excluded.current_time, connection_status=excluded.connection_status"));
    query.addBindValue(status.batteryLevel);
    query.addBindValue(status.currentTime.toUTC().toString(Qt::ISODate));
    query.addBindValue(status.connectionStatus);
    return query.exec();
}

bool Database::resetActivity()
{
    QSqlQuery clearActivity(m_db);
    if (!clearActivity.exec(QStringLiteral("DELETE FROM activity_records"))) {
        return false;
    }

    QSqlQuery clearNotifications(m_db);
    if (!clearNotifications.exec(QStringLiteral("DELETE FROM notifications"))) {
        return false;
    }

    QSqlQuery resetExercises(m_db);
    if (!resetExercises.exec(QStringLiteral("UPDATE relax_exercises SET completed = 0, completed_at = NULL"))) {
        return false;
    }

    ActivityRecord freshActivity;
    freshActivity.timestamp = QDateTime::currentDateTimeUtc();
    saveActivity(freshActivity);

    DeviceStatus status = deviceStatus();
    status.batteryLevel = 100;
    status.currentTime = freshActivity.timestamp;
    status.connectionStatus = QStringLiteral("connected");
    return saveDeviceStatus(status);
}

bool Database::createTables()
{
    const QStringList statements = {
        QStringLiteral("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT NOT NULL, avatar_placeholder TEXT NOT NULL, daily_step_goal INTEGER NOT NULL)"),
        QStringLiteral("CREATE TABLE IF NOT EXISTS activity_records (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT NOT NULL, steps INTEGER NOT NULL, calories INTEGER NOT NULL, goal_progress_percent INTEGER NOT NULL, heart_rate INTEGER NOT NULL)"),
        QStringLiteral("CREATE TABLE IF NOT EXISTS weather_cache (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT NOT NULL, current_temp REAL NOT NULL, current_description TEXT NOT NULL, tomorrow_min REAL NOT NULL, tomorrow_max REAL NOT NULL, tomorrow_description TEXT NOT NULL)"),
        QStringLiteral("CREATE TABLE IF NOT EXISTS relax_exercises (id INTEGER PRIMARY KEY, name TEXT NOT NULL, duration_seconds INTEGER NOT NULL, completed INTEGER NOT NULL DEFAULT 0, completed_at TEXT)"),
        QStringLiteral("CREATE TABLE IF NOT EXISTS notifications (id INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT NOT NULL, triggered_at TEXT NOT NULL, type TEXT NOT NULL)"),
        QStringLiteral("CREATE TABLE IF NOT EXISTS device_status (id INTEGER PRIMARY KEY CHECK(id = 1), battery_level INTEGER NOT NULL, current_time TEXT NOT NULL, connection_status TEXT NOT NULL)")
    };

    for (const auto &statement : statements) {
        QSqlQuery query(m_db);
        if (!query.exec(statement)) {
            qWarning() << "Failed to execute SQL" << statement << query.lastError();
            return false;
        }
    }

    return true;
}

bool Database::seedDefaults()
{
    if (!upsertUser(User{1, QStringLiteral("Kotek"), QStringLiteral("CAT"), 8000})) {
        return false;
    }

    QSqlQuery countExercises(m_db);
    countExercises.prepare(QStringLiteral("SELECT COUNT(*) FROM relax_exercises"));
    if (countExercises.exec() && countExercises.next() && countExercises.value(0).toInt() == 0) {
        const QList<RelaxExercise> defaults = {
            {1, QStringLiteral("Oddychaj spokojnie"), 60, false, {}},
            {2, QStringLiteral("Rozluźnij ramiona"), 90, false, {}},
            {3, QStringLiteral("Mrucz i policz do 10"), 45, false, {}},
        };

        for (const auto &exercise : defaults) {
            QSqlQuery insert(m_db);
            insert.prepare(QStringLiteral(
                "INSERT INTO relax_exercises (id, name, duration_seconds, completed, completed_at) VALUES (?, ?, ?, ?, NULL)"));
            insert.addBindValue(exercise.id);
            insert.addBindValue(exercise.name);
            insert.addBindValue(exercise.durationSeconds);
            insert.addBindValue(exercise.completed ? 1 : 0);
            if (!insert.exec()) {
                return false;
            }
        }
    }

    if (!latestActivity().timestamp.isValid()) {
        ActivityRecord record;
        record.timestamp = QDateTime::currentDateTimeUtc();
        if (!saveActivity(record)) {
            return false;
        }
    }

    if (!latestWeather().timestamp.isValid()) {
        WeatherData weather;
        weather.timestamp = QDateTime::currentDateTimeUtc();
        weather.currentTemp = 21.5;
        weather.currentDescription = QStringLiteral("Brak danych live");
        weather.tomorrowMin = 18.0;
        weather.tomorrowMax = 24.0;
        weather.tomorrowDescription = QStringLiteral("Pogoda z cache");
        if (!saveWeather(weather)) {
            return false;
        }
    }

    if (!deviceStatus().currentTime.isValid()) {
        DeviceStatus status;
        status.batteryLevel = 100;
        status.currentTime = QDateTime::currentDateTimeUtc();
        status.connectionStatus = QStringLiteral("connected");
        if (!saveDeviceStatus(status)) {
            return false;
        }
    }

    return true;
}

QString Database::databasePath() const
{
    return QDir(QCoreApplication::applicationDirPath()).filePath(QStringLiteral("kotekwatch.db"));
}
