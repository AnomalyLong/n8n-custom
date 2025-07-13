FROM n8nio/n8n:1.39.1-root

# Use node user to install the community node
USER node

RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install @telepilotco/n8n-nodes-telepilot

# Switch back to root for system-level access
USER root

# Copy the precompiled TDLib binary into the container
COPY libtdjson.so /usr/local/lib/libtdjson.so

# Copy the custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Launch our custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
