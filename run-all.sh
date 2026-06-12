#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_BIN="${ROOT_DIR}/build/backend/kotekwatch-backend"
FRONTEND_BIN="${ROOT_DIR}/build/frontend/kotekwatch-frontend"

if [[ ! -x "${BACKEND_BIN}" || ! -x "${FRONTEND_BIN}" ]]; then
    echo "Brakuje binarek. Najpierw zbuduj projekt: cmake -S . -B build && cmake --build build" >&2
    exit 1
fi

cleanup() {
    if [[ -n "${BACKEND_PID:-}" ]]; then
        kill "${BACKEND_PID}" 2>/dev/null || true
        wait "${BACKEND_PID}" 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM

"${BACKEND_BIN}" &
BACKEND_PID=$!

sleep 1

exec "${FRONTEND_BIN}"
