# KotekWatch

KotekWatch to prototyp interfejsu zegarka zbudowany w `Qt Quick/QML`. Aplikacja uruchamia pełnoekranowy, bezramkowy widok stylizowany na ekran smartwatcha i prezentuje kilka prostych ekranów z motywem kota.

## Co zawiera projekt

- ekran zegara z godziną i dniem tygodnia,
- ekran kroków z animowanym kotem i celem aktywności,
- ekran pogody z symulowaną temperaturą i stanem pogody,
- ekran `SOS` z animacją alarmu i anulowaniem przez dłuższe przytrzymanie,
- backend w C++, który dostarcza dane do QML przez `contextProperty`.

Nawigacja między ekranami działa poziomym przesunięciem w `SwipeView`.

## Technologie

- C++17
- CMake 3.16+
- Qt Quick
- Qt Quick Controls 2
- QML Shapes

Projekt jest przygotowany pod `Qt5` i `Qt6` przez `find_package(QT NAMES Qt6 Qt5 ...)`, ale rozwijany jest w układzie typowym dla `Qt 6`.

## Struktura

- `main.cpp` - start aplikacji, rejestracja fontów, konfiguracja okna i silnika QML
- `watchbackend.cpp`, `watchbackend.h` - symulowane dane czasu, kroków i pogody
- `qml/main.qml` - główne okno i `SwipeView`
- `qml/Screen*.qml` - osobne ekrany interfejsu
- `qml/Theme.qml` - kolory, rozmiary fontów i wspólne stałe UI
- `fonts/README.md` - informacja o opcjonalnych fontach lokalnych

## Wymagania

Do zbudowania projektu potrzebne są:

- kompilator C++ z obsługą C++17,
- `cmake`,
- pakiety deweloperskie `Qt Quick` i `Qt Quick Controls 2`.

Opcjonalnie można dodać fonty:

- `fonts/Fredoka-SemiBold.ttf`
- `fonts/Nunito-Bold.ttf`

Jeśli ich nie ma, Qt użyje fontów systemowych.

## Budowanie

```bash
cmake -S . -B build
cmake --build build
```

Konfiguracja została sprawdzona lokalnie poleceniem:

```bash
cmake -S . -B /tmp/kotekwatch-build
```

## Uruchomienie

```bash
./build/KotekWatch
```

Aplikacja:

- otwiera się jako okno bez ramek,
- przechodzi w tryb pełnoekranowy,
- ładuje interfejs z zasobów `qrc:/qml`.

## Jak działa backend

`WatchBackend` nie pobiera jeszcze danych z urządzenia ani z sieci. Zamiast tego:

- startuje z ustawioną datą `2026-06-15 10:30`,
- co sekundę przesuwa czas o `73` sekundy,
- zwiększa liczbę kroków w symulacji,
- cyklicznie zmienia stan pogody.

To oznacza, że projekt jest obecnie demonstratorem UI, a nie gotową aplikacją sprzętową.

## Ograniczenia

- brak integracji z prawdziwymi sensorami i API pogody,
- brak logiki połączenia alarmowego w ekranie `SOS`,
- brak testów automatycznych,
- rozmiar i zachowanie są dostrojone głównie pod prezentację interfejsu zegarka.
