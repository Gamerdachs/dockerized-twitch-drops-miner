# Pull base image
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Date as version
ARG APP_VERSION_ARG

# Environment
ENV APP_ICON_URL="https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png"

# Install latest Twitch Drops Miner
RUN \
    # Fix dangling symlinks for system files in the base image
    [ -L /etc/passwd ] && (rm /etc/passwd && echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd) || true && \
    [ -L /etc/group ] && (rm /etc/group && echo "root:x:0:" > /etc/group && echo "staff:x:50:" >> /etc/group) || true && \
    [ -L /etc/shadow ] && (rm /etc/shadow && echo "root:*:19768:0:99999:7:::" > /etc/shadow) || true && \
    [ -L /etc/gshadow ] && (rm /etc/gshadow && echo "root:*:*:" > /etc/gshadow) || true && \
    # Fix systemd installation error: mkdir: cannot create directory '/var/log': File exists
    # This happens because /var/log is a dangling symlink in the base image.
    # We also explicitly exclude systemd to avoid further configuration issues.
    mkdir -p /config/log && \
    apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        fonts-noto-color-emoji \
        gir1.2-appindicator3-0.1 \
        language-pack-en \
        unzip \
        wget \
        systemd- \
        systemd-sysv- \
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
    && set-cont-env APP_VERSION "$APP_VERSION_ARG"
