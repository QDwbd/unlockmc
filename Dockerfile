FROM --platform=$TARGETPLATFORM nginx:stable-alpine

LABEL org.opencontainers.image.title="Unlock Music"
LABEL org.opencontainers.image.description="Unlock encrypted music file in browser"
LABEL org.opencontainers.image.authors="QDwbd"
LABEL org.opencontainers.image.source="https://unlockmc.11150126.xyz"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="QDwbd"

COPY ./dist /usr/share/nginx/html
