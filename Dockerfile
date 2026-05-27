# You will want the custom seccomp profile:
# 	wget https://raw.githubusercontent.com/keithsecond/headed-chrome-cdp-mac/refs/heads/main/seccomp/chrome.json -O ~/chrome.json
#
# this updates from jess/chrome with perms for statx, openat2, clone3 

# docker run -d \
#	--net host \ # may as well YOLO
#	--cpuset-cpus 0 \ # control the cpu
#	--memory 512mb \ # max memory it can use
#       -p 127.0.0.1:9222:9222 \
#       -e DISPLAY=host.docker.internal:0 \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       -v "$HOME/chrome-cdp-profile:/data"
#	-v $HOME/Downloads:/home/chrome/Downloads \
#       --shm-size=2g \
#	--security-opt seccomp=$HOME/chrome.json \
#	--device /dev/snd \ # so we have sound
#       --device /dev/dri \
#	-v /dev/shm:/dev/shm \
#       --name chrome-cdp \
#       chrome-cdp:local

FROM jess/chrome:latest

# jess/chrome runs as `USER chrome`
# Switch back to root to install additional packages
# supervisord.conf handles de-escalation back to chrome
USER root

# Remove Google Chrome apt sources (optional cleanup)
RUN rm -f /etc/apt/sources.list.d/google*.list \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update

# Install supervisor and socat
RUN apt-get install -y \
    supervisor \
    socat \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/supervisor

# Copy your custom configs
COPY local.conf /etc/fonts/local.conf
COPY start-chrome.sh /usr/local/bin/start-chrome.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/local/bin/start-chrome.sh

EXPOSE 9222

# Stay as root — supervisord needs it to manage processes
ENTRYPOINT []
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
