#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_BIN="${ROOT_DIR}/build/backend/kotekwatch-backend"

if [[ ! -x "${BACKEND_BIN}" ]]; then
    echo "Brak ${BACKEND_BIN}. Najpierw zbuduj projekt: cmake -S . -B build && cmake --build build" >&2
    exit 1
fi

exec "${BACKEND_BIN}"
