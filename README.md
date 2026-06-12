# Kotek Watch

Minimalny prototyp składa się z dwóch projektów Qt/C++:

- `backend` - aplikacja konsolowa z REST API, WebSocket, SQLite i symulatorem danych zegarka.
- `frontend` - aplikacja Qt Quick/QML imitująca ekran smartwatcha 396x396.

## Wymagania

- Qt 6.4+ z modułami: `Core`, `Network`, `Sql`, `Quick`, `QuickControls2`
- CMake 3.21+
- Kompilator C++17

## OpenWeather

Backend próbuje pobierać pogodę z OpenWeather, jeśli ustawisz zmienną środowiskową:

```bash
export OPENWEATHER_API_KEY=twoj_klucz
```

Opcjonalnie możesz też ustawić:

```bash
export KOTEKWATCH_WEATHER_LAT=52.2297
export KOTEKWATCH_WEATHER_LON=21.0122
```

Jeśli klucz nie jest dostępny albo request się nie uda, backend zwraca dane z cache SQLite lub wartości zastępcze.

## Build

## Frontend Assets Setup

Przed budowaniem frontendu przygotuj przezroczyste assety:

```bash
python3 frontend/scripts/remove_bg.py frontend/assets/icons frontend/assets/icons/transparent
python3 frontend/scripts/remove_bg.py frontend/assets/illustrations frontend/assets/illustrations/transparent
```

Skrypt wykrywa tło `solid` albo `checkerboard`, usuwa je flood-fillem od narożników i zapisuje wynik do katalogu `transparent/`. Gdy wykrycie się nie powiedzie, plik zostaje skopiowany bez zmian i dostajesz ostrzeżenie do ręcznej weryfikacji.

Fonty `Fredoka-Bold.ttf` i `Nunito-Regular.ttf` dodaj do `frontend/assets/fonts/`. Frontend ma fallback do systemowego sans-serif, ale docelowy design zakłada te dwa pliki.

Budowanie obu komponentów z katalogu głównego:

```bash
cmake -S . -B build
cmake --build build
```

Albo osobno:

```bash
cmake -S backend -B backend/build
cmake --build backend/build

cmake -S frontend -B frontend/build
cmake --build frontend/build
```

## Uruchomienie

To są dwa osobne procesy. Backend nie uruchamia GUI.

Najprościej:

```bash
./run-all.sh
```

Albo osobno:

```bash
./run-backend.sh
./run-frontend.sh
```

Możesz też nadal odpalać binarki bezpośrednio:

```bash
./build/backend/kotekwatch-backend
./build/frontend/kotekwatch-frontend
```

Domyślne porty:

- REST: `http://127.0.0.1:8080`
- WebSocket: `ws://127.0.0.1:8081/ws`

Możesz je nadpisać:

```bash
export KOTEKWATCH_HTTP_PORT=18080
export KOTEKWATCH_WS_PORT=18081
export KOTEKWATCH_API_BASE_URL=http://127.0.0.1:18080
export KOTEKWATCH_WS_URL=ws://127.0.0.1:18081/ws
```

## API

- `GET /api/activity`
- `POST /api/activity`
- `POST /api/activity/reset`
- `GET /api/weather`
- `GET /api/relax/exercises`
- `POST /api/relax/complete/{id}`
- `GET /api/notifications`
- `GET /api/device/status`
- `POST /api/simulation/start`
- `POST /api/simulation/stop`

WebSocket `ws://127.0.0.1:8081/ws` wypycha live update z krokami, kaloriami, procentem celu, baterią i tętnem.
