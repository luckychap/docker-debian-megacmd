FROM curlimages/curl:7.72.0 AS downloader

WORKDIR /tmp
RUN curl https://mega.nz/linux/MEGAsync/Debian_10.0/amd64/megacmd_1.3.0-4.1_amd64.deb --output megacmd.deb

FROM debian:buster-slim

# Define labels
LABEL maintainer="lakatos.martin@gmail.com"
LABEL source_code="https://github.com/luckychap/docker-debian-megacmd"

# Install all dependecies
# https://github.com/meganz/MEGAcmd#requirements
RUN apt update -y \
    && apt install -y --no-install-recommends \
       libcrypto++ libpcrecpp0v5 libc-ares-dev zlib1g-dev libuv1 libssl-dev libsodium-dev readline-common sqlite3 curl automake make libtool g++ libcrypto++-dev libz-dev libsqlite3-dev libssl-dev libcurl4-gnutls-dev libreadline-dev libpcre++-dev libsodium-dev libc-ares-dev libfreeimage-dev libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libmediainfo-dev libzen-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt clean

# Get install pakage
COPY --from=downloader "/tmp/megacmd.deb" "/tmp/"

# Install megacmd and clean after
RUN apt update -y \
    && apt install -y --no-install-recommends \
        /tmp/megacmd.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt clean

# define command
CMD [ "mega-help" ]