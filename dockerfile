FROM n8nio/n8n:latest

USER node
RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install @telepilotco/n8n-nodes-telepilot

USER root
COPY libtdjson.so /usr/local/lib/libtdjson.so

# Inline ENTRYPOINT to copy .so file at runtime and then run n8n
ENTRYPOINT ["/bin/sh", "-c", "\
  cp /usr/local/lib/libtdjson.so /home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds/libtdjson.so && \
  exec /docker-entrypoint.sh \
"]
