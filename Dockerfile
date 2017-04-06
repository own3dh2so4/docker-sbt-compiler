FROM openjdk:8-alpine

MAINTAINER David Garcia <david.garcia.alvarez.93@gmail.com>

# Scala related variables
ARG SCALA_VERSION=2.11.7
ARG SCALA_BINARY_ARCHIVE_NAME=scala-${SCALA_VERSION}
ARG SCALA_BINARY_DOWNLOAD_URL=http://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_BINARY_ARCHIVE_NAME}.tgz

# SBT related variables
ARG SBT_VERSION=0.13.8
ARG SBT_BINARY_ARCHIVE_NAME=sbt-$SBT_VERSION
ARG SBT_BINARY_DOWNLOAD_URL=http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz

# Configure env variables for Scala, SBT and add to PATH.
ENV SCALA_HOME  /usr/local/${SCALA_BINARY_ARCHIVE_NAME}
ENV SBT_HOME    /usr/local/sbt
ENV PATH ${PATH}:${SCALA_HOME}/bin:${SBT_HOME}/bin

# VARIABLES TO INSTALL GNU libc (aka glibc)
ENV ALPINE_GLIBC_BASE_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download
ENV ALPINE_GLIBC_PACKAGE_VERSION 2.25-r0
ENV ALPINE_GLIBC_BASE_PACKAGE_FILENAME glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk
ENV ALPINE_GLIBC_BIN_PACKAGE_FILENAME glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk
ENV ALPINE_GLIBC_I18N_PACKAGE_FILENAME glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk


ENV LANG=C.UTF-8


# Install GLIBC
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

ENV LANG=C.UTF-8

# Install basic packages
RUN apk add --update --no-cache bash fping glibc libcap openssl unzip && \
    rm -rf /var/cache/apk/*

# Install Scala
## Piping curl directly in tar
RUN \
  wget "${SCALA_BINARY_DOWNLOAD_URL}" && \
  tar -xvzf scala-${SCALA_VERSION}.tgz  && \
  cp -a scala-${SCALA_VERSION}/* /usr/local && rm -rf scala-${SCALA_VERSION} && rm -rf scala-${SCALA_VERSION}.tgz && \
  echo >> /root/.bashrc && \
  echo -ne "- with scala $SCALA_VERSION\n" >> /root/.built

# Install sbt
RUN apk add --no-cache --update bash && \
    wget "${SBT_BINARY_DOWNLOAD_URL}" && \
    tar -xvzf sbt-${SBT_VERSION}.tgz && \
    cp -a sbt/* /usr/local && rm -rf sbt && rm -rf sbt-${SBT_VERSION}.tgz && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

WORKDIR /app
