# syntax=docker/dockerfile:1

# Runtime Stage
FROM ghcr.io/linuxserver/baseimage-selkies:arch

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WORKBENCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV TITLE="MySQL Workbench" \
    NO_GAMEPAD="true" \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mysql-workbench-logo.png && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm \
   gnome-keyring \
   libsecret \
   "mysql-workbench${WORKBENCH_VERSION:+=$WORKBENCH_VERSION}" \
   seahorse && \
  mv \
    /usr/sbin/mysql-workbench \
    /usr/sbin/mysql-workbench-real && \
  echo "**** cleanup ****" && \
  printf \
    "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" \
    > /build_version && \
  pacman -Scc --noconfirm && \
  rm -rf \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files and files from buildstage
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 3001
