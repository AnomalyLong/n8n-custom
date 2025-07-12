FROM n8nio/n8n:latest

# Switch to node user
USER node

# Install TelePilot community node
RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install @telepilotco/n8n-nodes-telepilot

# Switch back to root
USER root

# Copy prebuilt tdlib binaries (or install them manually below)
COPY libtdjson.so /usr/local/lib/libtdjson.so

# Link or move the .so to where the community node expects it
RUN mkdir -p /home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds/ \
  && cp /usr/local/lib/libtdjson.so /home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds/libtdjson.so

# Fix permissions
RUN chown -R node:node /home/node/.n8n

USER node

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
