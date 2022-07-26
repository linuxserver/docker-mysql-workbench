FROM ghcr.io/linuxserver/baseimage-rdesktop-web:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WORKBENCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
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
    libopengl0 \
    libpangomm-1.4-1v5 \
    libpcrecpp0v5 \
    libproj22 \
    libpython3.10 \
    libsecret-1-0 \
    libsigc++-2.0-0v5 \
    libssh-4 \
    libvsqlitepp3v5 \
    libzip4 && \
  echo "**** install mysql workbench ****" && \
  if [ -z ${WORKBENCH_VERSION+x} ]; then \
    WORKBENCH_VERSION=$(curl -sL https://dev.mysql.com/downloads/workbench/ \
    |awk '/<h1>MySQL Workbench/ {print $3;exit}'); \
  fi && \
  curl -Lf -o \
    /tmp/workbench.deb \
    https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community_${WORKBENCH_VERSION}-1ubuntu22.04_amd64.deb && \
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
EXPOSE 3000
VOLUME /config
