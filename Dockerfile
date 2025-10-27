# Use Alpine Linux as the base image for a small-footprint container
FROM alpine:latest

# Default environment variables (can be overridden with `docker run -e`)
ENV SERVER_DOMAIN=example.clawcloudrun.com
ENV UDP_PORT=5678
ENV PASSWORD=your-uuid-password

# Install dependencies and create required directories
RUN apk update && \
    apk add --no-cache curl wget openssl bash ca-certificates && \
    mkdir -p /etc/hysteria

# Download the hysteria2 binary
RUN wget -q -O /usr/local/bin/hysteria https://download.hysteria.network/app/latest/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

# Self-signed TLS certificate (for testing/demo purposes)
RUN openssl ecparam -genkey -name prime256v1 -noout -out /etc/hysteria/server.key && \
    openssl req -x509 -new -key /etc/hysteria/server.key \
    -out /etc/hysteria/server.crt \
    -subj "/CN=bing.com" -days 36500

# Copy the entrypoint startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the configured UDP port (example; actual host mapping controlled by docker run -p)
EXPOSE ${UDP_PORT}/udp

# Use the entrypoint script as the container entrypoint
ENTRYPOINT ["/entrypoint.sh"]
