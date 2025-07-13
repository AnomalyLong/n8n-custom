FROM n8nio/n8n:latest

# Switch to node user
USER node

# Install TelePilot node
RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install @telepilotco/n8n-nodes-telepilot

# Switch back to root
USER root

# Copy libtdjson.so into the image
COPY libtdjson.so /usr/local/lib/libtdjson.so

# Use entrypoint to copy libtdjson.so at runtime
RUN echo '#!/bin/bash\n' \
         'cp /usr/local/lib/libtdjson.so /home/node/.n8n/nodes/node_modules/@telepilotco/tdlib-binaries-prebuilt/prebuilds/libtdjson.so\n' \
         '/docker-entrypoint.sh' > /entry.sh && \
    chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]
