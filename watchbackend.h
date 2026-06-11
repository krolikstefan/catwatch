#pragma once

#include <QDateTime>
#include <QObject>
#include <QTimer>

class WatchBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString timeText READ timeText NOTIFY timeTextChanged)
    Q_PROPERTY(QString weekdayText READ weekdayText NOTIFY weekdayTextChanged)
    Q_PROPERTY(int stepCount READ stepCount NOTIFY stepCountChanged)
    Q_PROPERTY(int stepGoal READ stepGoal CONSTANT)
    Q_PROPERTY(QString stepGoalText READ stepGoalText NOTIFY stepCountChanged)
    Q_PROPERTY(QString temperatureText READ temperatureText NOTIFY weatherChanged)
    Q_PROPERTY(QString weatherText READ weatherText NOTIFY weatherChanged)

public:
    explicit WatchBackend(QObject *parent = nullptr);

    QString timeText() const;
    QString weekdayText() const;
    int stepCount() const;
    int stepGoal() const;
    QString stepGoalText() const;
    QString temperatureText() const;
    QString weatherText() const;

signals:
    void timeTextChanged();
    void weekdayTextChanged();
    void stepCountChanged();
    void weatherChanged();

private:
    void tick();

    QDateTime m_currentDateTime;
    QTimer m_timer;
    int m_stepCount = 245;
    int m_stepGoal = 4280;
    int m_tickCount = 0;
    int m_weatherIndex = 0;
};
