# Pull base image
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Date as version
ARG APP_VERSION_ARG

# Environment
ENV APP_ICON_URL https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png

# Install latest Twitch Drops Miner
RUN apt-get update -y \
    && apt-get install -y fonts-noto-color-emoji gir1.2-appindicator3-0.1 language-pack-en libc6 unzip wget \
    && apt-get clean \
    && wget -P /tmp/ https://github.com/DevilXD/TwitchDropsMiner/releases/download/dev-build/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip \
    && mkdir /TwitchDropsMiner \
    && unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" >/TwitchDropsMiner/TwitchDropsMiner \
    && chmod +x /TwitchDropsMiner/TwitchDropsMiner \
    
    && mkdir /TwitchDropsMiner/config \
    && ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json \
    && ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar \
    && chmod -R 777 /TwitchDropsMiner \
    && echo "#!/bin/sh" > /startapp.sh \
    && echo "exec /TwitchDropsMiner/TwitchDropsMiner" >> /startapp.sh \
    && chmod +x /startapp.sh \
    && install_app_icon.sh "$APP_ICON_URL" \
    && set-cont-env APP_NAME "Twitch Drops Miner" \
    && set-cont-env APP_VERSION "$APP_VERSION_ARG" \
