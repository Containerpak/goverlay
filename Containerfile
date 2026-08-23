FROM ubuntu:26.04 AS source

ADD --checksum=sha256:93f39216ef6e5c34ca30e47746fa5ad22d7c9c9c6867ce8cc4ba0cf508cfdd80 https://github.com/benjamimgois/goverlay/releases/download/1.9.0/goverlay-1.9.0-x86_64.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/goverlay"

COPY --from=source /stage/ /opt/goverlay/
COPY goverlay /usr/bin/goverlay
COPY goverlay.desktop /usr/share/applications/goverlay.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/goverlay.png

RUN chmod 0755 /usr/bin/goverlay && cpak-clean-junk

