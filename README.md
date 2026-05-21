# chrome-cdp-mac

Headed Chrome in a Docker container with CDP exposed on port 9222, intended
for running Playwright/CDP tests against a real Chrome instance on macOS
(via XQuartz for the display).

## Files

- `Dockerfile` — builds the image
- `start-chrome.sh` — Chrome launch command (runs inside the container under supervisord)
- `supervisord.conf` — runs Chrome + socat (bridges 9222 → 127.0.0.1:9223)
- `local.conf` — fontconfig
- `seccomp/chrome.json` — seccomp profile from jfrazelle/dotfiles, added statx, openat2, clone3
- `cdprun` — convenience script to launch the container with the right host env

## Prerequisites (macOS)

- Docker Desktop
- XQuartz with "Allow connections from network clients" enabled
- `xhost +<your-lan-ip>` before running

## Build

    docker build -t chrome-cdp:local .

## Run

    cp seccomp/chrome.json ~/chrome.json
    ./cdprun

## Verify

    curl http://127.0.0.1:9222/json/version

## Credits 

    [Jess Frazelle](https://github.com/jessfraz)
