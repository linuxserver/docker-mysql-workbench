# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WORKBENCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ARG DEBIAN_FRONTEND="noninteractive"

# title
ENV TITLE=MySQL-Workbench

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mysql-workbench-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    gnome-keyring \
    libatkmm-1.6-1v5 \
    libcairomm-1.0-1v5 \
    libglibmm-2.4-1v5 \
    libgtk2.0-0 \
    libgtkmm-3.0-1v5 \
    libmysqlclient21 \
    libodbc2 \
    libopengl0 \
    libpangomm-1.4-1v5 \
    libpcrecpp0v5 \
    libproj25 \
    libpython3.12t64 \
    libsecret-1-0 \
    libsigc++-2.0-0v5 \
    libssh-4 \
    libvsqlitepp3v5 \
    libzip4t64 && \
  echo "**** install mysql workbench ****" && \
  if [ -z ${WORKBENCH_VERSION+x} ]; then \
    WORKBENCH_VERSION=$(curl -sL https://dev.mysql.com/downloads/workbench/ \
    |awk '/<h1>MySQL Workbench/ {print $3;exit}'); \
  fi && \
  curl -Lf -o \
    /tmp/workbench.deb \
    https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community_${WORKBENCH_VERSION}-1ubuntu24.04_amd64.deb && \
  dpkg -i /tmp/workbench.deb && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001
VOLUME /config
