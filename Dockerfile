FROM alpine:3.14 as base

# ------------------------------------
# AWS CLI v2

# install glibc compatibility for alpine
ENV GLIBC_VER=2.31-r0
ENV AWS_CLI_VERSION=2.2.36

RUN apk --no-cache add \
    binutils \
    curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
    glibc-${GLIBC_VER}.apk \
    glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
    awscliv2.zip \
    aws \
    /usr/local/aws-cli/v2/*/dist/aws_completer \
    /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
    binutils \
    curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

# ------------------------------------
# gettext
RUN apk add --no-cache gettext libintl

# ------------------------------------
# Jsonnet and JQ
RUN apk add --no-cache jsonnet jq

FROM base as docker

# ------------------------------------
# DOCKER
RUN apk add --update docker openrc
RUN rc-update add docker boot

FROM docker as terraform

# ------------------------------------
# Installs Terraform
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache terraform=1.3.8-r1