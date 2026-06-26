# headed-chrome-cdp-mac

Headed Chromium in a Docker container with CDP exposed on port 9222, intended
for running Playwright/CDP tests against a real browser instance on macOS
(via XQuartz for the display). Multi-arch image (amd64 + arm64).

## Files

- `Dockerfile` — builds the image
- `start-chrome.sh` — Chromium launch command (runs inside the container under supervisord)
- `supervisord.conf` — runs Chromium + socat (bridges 9222 → 127.0.0.1:9223)
- `local.conf` — fontconfig
- `seccomp/chrome.json` — seccomp profile from jfrazelle/dotfiles with added statx, openat2, clone3
- `cdprun` — convenience script to launch the container with the right host env

## Prerequisites (macOS)

- Docker Desktop
- XQuartz with "Allow connections from network clients" enabled
- `xhost +<your-lan-ip>` before running

## Build

    docker build -t chrome-cdp:local .

To build for both amd64 and arm64 (e.g. via `docker buildx`):

    docker buildx build --platform linux/amd64,linux/arm64 -t chrome-cdp:local .

## Run

    cp seccomp/chrome.json ~/chrome.json
    mkdir ~/chrome-cdp-profile
    ./cdprun

## Verify

    curl http://127.0.0.1:9222/json/version

## Credits 

[Jess Frazelle](https://github.com/jessfraz) for [jess/chrome](https://github.com/jessfraz/dockerfiles/tree/master/chrome)
