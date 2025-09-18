# Build Radicale v3 Docker image
FROM python:3.11-alpine

# Install dependencies
RUN apk add --no-cache \
  gcc \
  musl-dev \
  libffi-dev \
  ca-certificates \
  openssl \
  python3-dev

# Create radicale user and directories
RUN adduser -D -h /var/lib/radicale -s /bin/false radicale && \
  mkdir -p /etc/radicale /var/lib/radicale/collections && \
  chown -R radicale:radicale /var/lib/radicale /etc/radicale

# Install Radicale and optional dependencies
ARG RADICALE_VERSION
RUN pip install --no-cache-dir \
  radicale==${RADICALE_VERSION} \
  passlib \
  bcrypt

# Copy configuration
COPY config /etc/radicale/config
RUN chown radicale:radicale /etc/radicale/config

# Set up volumes
VOLUME ["/var/lib/radicale/collections", "/etc/radicale"]

# Expose default port
EXPOSE 5232

# Switch to radicale user
USER radicale

# Run Radicale
CMD ["radicale", "--config", "/etc/radicale/config"]
