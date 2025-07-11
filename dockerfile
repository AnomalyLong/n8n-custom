FROM n8nio/n8n:latest

# Add the custom node
RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install @telepilotco/n8n-nodes-telepilot

# Set permissions
RUN chown -R node:node /home/node/.n8n

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]