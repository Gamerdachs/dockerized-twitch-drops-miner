# Pull base image
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Date as version
ARG APP_VERSION_ARG

# Environment
ENV APP_ICON_URL="https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png"

# Install latest Twitch Drops Miner and Chromium browser for zendriver auth
RUN \
    add-pkg \
        ca-certificates \
        fonts-noto-color-emoji \
        gir1.2-appindicator3-0.1 \
        language-pack-en \
        unzip \
        wget \
        libglib2.0-0 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libdrm2 \
        libdbus-1-3 \
        libgdk-pixbuf2.0-0 \
        libnspr4 \
        libpango-1.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libgbm1 \
        libpci3 \
        libasound2t64 \
        fonts-liberation \
    && wget -qO /tmp/chromium.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update && apt-get install -y /tmp/chromium.deb \
    && rm -f /tmp/chromium.deb \
    && wget -P /tmp/ https://github.com/DevilXD/TwitchDropsMiner/releases/download/dev-build/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip \
    && mkdir -p /TwitchDropsMiner/config/cache \
    && unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" > /TwitchDropsMiner/TwitchDropsMiner \
    && rm -f /tmp/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip \
    && chmod +x /TwitchDropsMiner/TwitchDropsMiner \
    && ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json \
    && ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar \
    && ln -s /TwitchDropsMiner/config/log.txt /TwitchDropsMiner/log.txt \
    && ln -s /TwitchDropsMiner/config/cache /TwitchDropsMiner/cache \
    && printf '#!/bin/sh\nset -e\nmkdir -p /TwitchDropsMiner/config/cache\nmkdir -p "$HOME/.config/autostart"\nchown -R "$USER_ID:$GROUP_ID" /TwitchDropsMiner /TwitchDropsMiner/config\n' > /etc/cont-init.d/55-twitch-drops-miner.sh \
    && chmod +x /etc/cont-init.d/55-twitch-drops-miner.sh \
    && printf '#!/bin/sh\ncd /TwitchDropsMiner\nexport HOME=/TwitchDropsMiner/config\nexec s6-setuidgid 1000:1000 /TwitchDropsMiner/TwitchDropsMiner\n' > /startapp.sh \
    && chmod +x /startapp.sh \
    && install_app_icon.sh "$APP_ICON_URL" \
    && set-cont-env APP_NAME "Twitch Drops Miner" \
    && set-cont-env APP_VERSION "$APP_VERSION_ARG"