# Pull base image
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Date as version
ARG APP_VERSION_ARG
ARG TDM_REF=dev-build

# Environment
ENV APP_ICON_URL="https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png"

# Install latest Twitch Drops Miner from source.
RUN \
    add-pkg \
        ca-certificates \
        fonts-noto-color-emoji \
        fonts-liberation \
        gir1.2-appindicator3-0.1 \
        language-pack-en \
        python3 \
        python3-gi \
        python3-tk \
        python3-venv \
        wget \
        systemd- \
        systemd-sysv- \
    && wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y /tmp/google-chrome.deb \
    && rm -f /tmp/google-chrome.deb \
    && rm -f /usr/bin/google-chrome \
    && printf '#!/bin/sh\nexec /opt/google/chrome/google-chrome --no-sandbox --disable-dev-shm-usage --disable-gpu "$@"\n' > /usr/bin/google-chrome \
    && chmod +x /usr/bin/google-chrome \
    && wget -q -O /tmp/tdm.tar.gz "https://github.com/DevilXD/TwitchDropsMiner/archive/refs/tags/${TDM_REF}.tar.gz" \
    && mkdir -p /TwitchDropsMiner/config/cache \
    && tar -xzf /tmp/tdm.tar.gz --strip-components=1 -C /TwitchDropsMiner \
    && rm -f /tmp/tdm.tar.gz \
    && python3 -m venv --system-site-packages /TwitchDropsMiner/env \
    && grep -v 'PyGObject' /TwitchDropsMiner/requirements.txt > /tmp/tdm-requirements.txt \
    && /TwitchDropsMiner/env/bin/pip install --no-cache-dir -r /tmp/tdm-requirements.txt \
    && rm -f /tmp/tdm-requirements.txt \
    && ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json \
    && ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar \
    && ln -s /TwitchDropsMiner/config/log.txt /TwitchDropsMiner/log.txt \
    && ln -s /TwitchDropsMiner/config/cache /TwitchDropsMiner/cache \
    && printf '#!/bin/sh\nset -e\nmkdir -p /TwitchDropsMiner/config/cache\nmkdir -p "$HOME/.config/autostart"\nchown -R "$USER_ID:$GROUP_ID" /TwitchDropsMiner /TwitchDropsMiner/config\n' > /etc/cont-init.d/55-twitch-drops-miner.sh \
    && chmod +x /etc/cont-init.d/55-twitch-drops-miner.sh \
    && printf '#!/bin/sh\ncd /TwitchDropsMiner\nexec /TwitchDropsMiner/env/bin/python main.py\n' > /startapp.sh \
    && chmod +x /startapp.sh \
    && install_app_icon.sh "$APP_ICON_URL" \
    && set-cont-env APP_NAME "Twitch Drops Miner" \
    && set-cont-env APP_VERSION "$APP_VERSION_ARG"