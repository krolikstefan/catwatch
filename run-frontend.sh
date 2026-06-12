#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_BIN="${ROOT_DIR}/build/frontend/kotekwatch-frontend"

if [[ ! -x "${FRONTEND_BIN}" ]]; then
    echo "Brak ${FRONTEND_BIN}. Najpierw zbuduj projekt: cmake -S . -B build && cmake --build build" >&2
    exit 1
fi

exec "${FRONTEND_BIN}"
