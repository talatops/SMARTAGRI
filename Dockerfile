# syntax=docker/dockerfile:1

############################
# Stage 1: build Flutter web
############################
# ghcr.io/cirruslabs/flutter is stale (newest tag 3.44.0) so we bootstrap the
# official Flutter SDK tarball from Google's release archive instead.
FROM ubuntu:24.04 AS build

ARG FLUTTER_VERSION=3.47.6
ARG FLUTTER_CHANNEL=stable
# Optional sha256 of the tarball; left empty skips verification
ARG FLUTTER_SHA256=

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_ROOT=/opt/flutter

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git unzip xz-utils zip \
    && rm -rf /var/lib/apt/lists/*

# User mode Linux runs must not be executed as root, so build as a regular user.
# UID 1000 is already taken by the base image's default user, so let useradd pick one.
RUN useradd -m -d /home/flutter flutter

RUN curl -fsSL -o /tmp/flutter.tar.xz \
    "https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz" \
    && if [ -n "${FLUTTER_SHA256}" ]; then \
         echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c -; \
       fi \
    && tar -xJf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz \
    && chown -R flutter:flutter /opt/flutter /home/flutter

ENV PATH="/opt/flutter/bin:${PATH}" \
    PUB_CACHE=/home/flutter/.pub-cache

USER flutter
WORKDIR /app

# Cache dependencies first so source edits don't re-download packages
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./
RUN flutter config --no-analytics \
    && flutter pub get

# Now the rest of the source
COPY --chown=flutter:flutter . .
RUN flutter pub get --offline || flutter pub get

# --wasm also produces the JS fallback build (main.dart.js)
ARG BUILD_FLAGS="--release --wasm"
# Changes whenever ENV_PROD changes, so Docker never reuses an old build
ARG ENV_HASH=none

# The env file is mounted as a BuildKit secret: not stored in layers or build args.
# mode=0444 so the unprivileged 'flutter' build user can read it (secrets default to root:root 0400).
# Docker/build-only keys (notably the framework-reserved FLUTTER_VERSION) are stripped before
# handing the file to Dart; only genuine app dart-defines are passed through --dart-define-from-file.
RUN --mount=type=secret,id=app_env,target=/tmp/app_env,mode=0444 \
    : "${ENV_HASH}" \
    && grep -aE '^[A-Za-z_][A-Za-z0-9_]*=' /tmp/app_env \
       | grep -avE '^(FLUTTER_VERSION|FLUTTER_CHANNEL|FLUTTER_SHA256|BUILD_FLAGS|ENV_HASH|HOST_PORT|PORT|IMAGE_NAME|IMAGE_TAG|CONTAINER_NAME|NGINX_SERVER_NAME|TRUSTED_PROXY_CIDR|STATIC_CACHE_DAYS)=' \
       > /tmp/dart_defines.env || true \
    && if [ -s /tmp/dart_defines.env ]; then \
         flutter build web ${BUILD_FLAGS} --dart-define-from-file=/tmp/dart_defines.env; \
       else \
         flutter build web ${BUILD_FLAGS}; \
       fi

############################
# Stage 2: runtime (nginx)
############################
FROM nginx:alpine AS runtime

# Only the compiled site is copied: no SDK, no source
COPY --from=build /app/build/web /usr/share/nginx/html

# The official nginx image renders *.template files with envsubst at startup
COPY docker/nginx.conf.template /etc/nginx/templates/default.conf.template

ENV NGINX_SERVER_NAME=_ \
    TRUSTED_PROXY_CIDR=0.0.0.0/0 \
    STATIC_CACHE_DAYS=30

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/healthz || exit 1