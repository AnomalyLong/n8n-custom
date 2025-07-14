FROM n8nio/n8n:1.17.0

USER node
RUN mkdir -p /home/node/.n8n/nodes && \
    cd /home/node/.n8n/nodes && \
    npm install @telepilotco/n8n-nodes-telepilot

USER root

COPY libtdjson.so /usr/local/lib/libtdjson.so

# Inject corrected entrypoint
RUN cat << 'EOF' > /entrypoint.sh
#!/bin/sh

LIB_PATH=/usr/local/lib/libtdjson.so
TDLIB_RELATIVE=nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds
NODE_N8N=/home/node/.n8n/$TDLIB_RELATIVE
ROOT_N8N=/root/.n8n/$TDLIB_RELATIVE

mkdir -p "$NODE_N8N"
mkdir -p "$ROOT_N8N"

cp "$LIB_PATH" "$NODE_N8N/libtdjson.so"
cp "$LIB_PATH" "$ROOT_N8N/libtdjson.so"

exec /docker-entrypoint.sh
EOF

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
