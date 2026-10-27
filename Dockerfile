# Pull base image
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Date as version
ARG APP_VERSION_ARG

# Environment
ENV APP_ICON_URL="https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png"

# Install latest Twitch Drops Miner
RUN \
    add-pkg \
        ca-certificates \
        fonts-noto-color-emoji \
        gir1.2-appindicator3-0.1 \
        language-pack-en \
        unzip \
        wget \
        systemd- \
        systemd-sysv- \
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
    && printf '#!/bin/sh\ncd /TwitchDropsMiner\nexec /TwitchDropsMiner/TwitchDropsMiner\n' > /startapp.sh \
    && chmod +x /startapp.sh \
    && install_app_icon.sh "$APP_ICON_URL" \
    && set-cont-env APP_NAME "Twitch Drops Miner" \
    && set-cont-env APP_VERSION "$APP_VERSION_ARG"