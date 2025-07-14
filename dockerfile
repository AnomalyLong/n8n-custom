FROM n8nio/n8n:1.17.0

USER node
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm install @telepilotco/n8n-nodes-telepilot

USER root

COPY libtdjson.so /usr/local/lib/libtdjson.so

# Safely create entrypoint.sh using echo line-by-line
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'LIB_PATH=/usr/local/lib/libtdjson.so' >> /entrypoint.sh && \
    echo 'TDLIB_RELATIVE=nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds' >> /entrypoint.sh && \
    echo 'NODE_N8N=/home/node/.n8n/$TDLIB_RELATIVE' >> /entrypoint.sh && \
    echo 'ROOT_N8N=/root/.n8n/$TDLIB_RELATIVE' >> /entrypoint.sh && \
    echo 'mkdir -p "$NODE_N8N"' >> /entrypoint.sh && \
    echo 'mkdir -p "$ROOT_N8N"' >> /entrypoint.sh && \
    echo 'cp "$LIB_PATH" "$NODE_N8N/libtdjson.so"' >> /entrypoint.sh && \
    echo 'cp "$LIB_PATH" "$ROOT_N8N/libtdjson.so"' >> /entrypoint.sh && \
    echo 'exec /docker-entrypoint.sh' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
