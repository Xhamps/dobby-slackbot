ARG ALPINE_VERSION=3.8

FROM elixir:1.7.2-alpine AS builder

ARG MIX_ENV=prod
ARG APP_NAME
ARG APP_VSN
ARG SLACK_TOKEN
ARG GITHUB_TOKEN
ARG GITHUB_ORG

ENV MIX_ENV=${MIX_ENV} \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    SLACK_TOKEN=${SLACK_TOKEN} \
    GITHUB_TOKEN=${GITHUB_TOKEN} \
    GITHUB_ORG=${GITHUB_ORG}

WORKDIR /opt/app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  nodejs \
  yarn \
  git \
  build-base && \
  mix local.rebar --force && \
  mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN \
  mkdir -p /opt/built && \
  mix release --verbose && \
  cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
  cd /opt/built && \
  tar -xzf ${APP_NAME}.tar.gz && \
  rm ${APP_NAME}.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME

RUN apk update && \
  apk add --no-cache \
  bash \
  openssl-dev

ENV REPLACE_OS_VARS=true \
APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
