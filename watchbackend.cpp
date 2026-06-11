#include "watchbackend.h"

#include <QStringList>

namespace {

struct WeatherState {
    QString temperature;
    QString label;
};

const WeatherState kWeatherStates[] = {
    {QStringLiteral("22\u00B0"), QStringLiteral("Slonecznie")},
    {QStringLiteral("19\u00B0"), QStringLiteral("Chmurki")},
    {QStringLiteral("17\u00B0"), QStringLiteral("Lekki deszcz")},
    {QStringLiteral("24\u00B0"), QStringLiteral("Bardzo cieplo")},
};

}

WatchBackend::WatchBackend(QObject *parent)
    : QObject(parent)
    , m_currentDateTime(QDateTime(QDate(2026, 6, 15), QTime(10, 30)))
{
    m_timer.setInterval(1000);
    connect(&m_timer, &QTimer::timeout, this, [this] { tick(); });
    m_timer.start();
}

QString WatchBackend::timeText() const
{
    return m_currentDateTime.time().toString(QStringLiteral("HH:mm"));
}

QString WatchBackend::weekdayText() const
{
    static const QStringList weekdays = {
        QStringLiteral("Pon"),
        QStringLiteral("Wt"),
        QStringLiteral("Sr"),
        QStringLiteral("Czw"),
        QStringLiteral("Pt"),
        QStringLiteral("Sob"),
        QStringLiteral("Niedz")
    };

    const int index = m_currentDateTime.date().dayOfWeek() - 1;
    return weekdays.value(index, QStringLiteral("Pon"));
}

int WatchBackend::stepCount() const
{
    return m_stepCount;
}

int WatchBackend::stepGoal() const
{
    return m_stepGoal;
}

QString WatchBackend::stepGoalText() const
{
    return QStringLiteral("Cel %1").arg(m_stepGoal);
}

QString WatchBackend::temperatureText() const
{
    return kWeatherStates[m_weatherIndex].temperature;
}

QString WatchBackend::weatherText() const
{
    return kWeatherStates[m_weatherIndex].label;
}

void WatchBackend::tick()
{
    const QString previousTime = timeText();
    const QString previousDay = weekdayText();

    m_currentDateTime = m_currentDateTime.addSecs(73);
    m_stepCount += 18 + (m_tickCount % 3) * 7;
    if (m_stepCount > 9999) {
        m_stepCount = 245;
    }

    ++m_tickCount;
    if (m_tickCount % 8 == 0) {
        m_weatherIndex = (m_weatherIndex + 1) % (sizeof(kWeatherStates) / sizeof(kWeatherStates[0]));
        emit weatherChanged();
    }

    if (previousTime != timeText()) {
        emit timeTextChanged();
    }

    if (previousDay != weekdayText()) {
        emit weekdayTextChanged();
    }

    emit stepCountChanged();
}
