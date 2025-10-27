#!/bin/bash

set -e

# Generate hysteria config from environment variables
cat > /etc/hysteria/config.yaml <<EOF
listen: :${UDP_PORT}

tls:
  cert: /etc/hysteria/server.crt
  key: /etc/hysteria/server.key

auth:
  type: password
  password: ${PASSWORD}

masquerade:
  type: proxy
  proxy:
    url: https://bing.com/
    rewriteHost: true
EOF

# Start hysteria in background
/usr/local/bin/hysteria server -c /etc/hysteria/config.yaml &
sleep 1

# Fetch public IP and country code for display
SERVER_IP=$(curl -s https://api.ipify.org)
COUNTRY_CODE=$(curl -s https://ipapi.co/${SERVER_IP}/country/ || echo "XX")

echo
echo "------------------------------------------------------------------------"
echo "✅ Hysteria2 started successfully"
echo "Listening port (UDP): ${UDP_PORT}"
echo "Password: ${PASSWORD}"
echo "------------------------------------------------------------------------"
echo "🎯 Client connection config (replace the port with the public UDP port assigned by Claw Cloud):"
echo "hy2://${PASSWORD}@${SERVER_DOMAIN}:${UDP_PORT}?sni=bing.com&insecure=1#claw.cloud-hy2-${COUNTRY_CODE}"
echo "------------------------------------------------------------------------"

wait
