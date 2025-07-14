### Stage 1: Build libtdjson.so inside Alpine
FROM alpine:3.19 as tdlib-builder

RUN apk update && apk add alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake php

WORKDIR /td
RUN git clone --depth=1 https://github.com/tdlib/td.git .

RUN mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib .. && \
    cmake --build . --target install

### Stage 2: Build custom n8n with TDLib support
FROM n8nio/n8n:1.17.0

# Install TelePilot community node
USER node
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm install @telepilotco/n8n-nodes-telepilot

# Switch to root for system setup
USER root

# Copy TDLib binary from builder stage
COPY --from=tdlib-builder /td/tdlib/lib/libtdjson.so /usr/local/lib/libtdjson.so

# Add runtime entrypoint script inline
RUN printf '%s\n' '#!/bin/sh' \
'TARGET_NODE=/home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds' \
'TARGET_ROOT=/root/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds' \
'mkdir -p "$TARGET_NODE"' \
'mkdir -p "$TARGET_ROOT"' \
'cp /usr/local/lib/libtdjson.so "$TARGET_NODE/libtdjson.so"' \
'cp /usr/local/lib/libtdjson.so "$TARGET_ROOT/libtdjson.so"' \
'exec /docker-entrypoint.sh' > /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
