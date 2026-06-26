#!/bin/bash

# Cleanup stale profile from old containers
rm -f /data/SingletonLock /data/SingletonCookie /data/SingletonSocket

exec chromium \
  --user-data-dir=/data/ \
  --remote-debugging-port=9223 \
  --remote-debugging-address=0.0.0.0 \
  --no-sandbox \
  --window-size=811,605 \
  --disable-dev-shm-usage \
  --no-first-run \
  --no-default-browser-check

