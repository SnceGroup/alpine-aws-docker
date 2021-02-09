FROM alpine:latest

# ------------------------------------
# AWS CLI
RUN apk update \
    && apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

# ------------------------------------
# DOCKER
RUN apk add --update docker openrc
RUN rc-update add docker boot
