# Radicale Docker Auto-Build

Automatic GitHub pipeline for building and publishing Radicale (https://radicale.org) Docker images to GitHub Container Registry (GHCR).

## Features

- Monitors upstream Radicale releases hourly
- Automatically builds multi-arch Docker images (amd64/arm64)
- Publishes to GHCR with version and `latest` tags
- Creates GitHub releases for tracking

## Setup

### 1. Create Repository

Create a new GitHub repository and add these files:
- `Dockerfile`
- `config` (Radicale configuration)
- `.github/workflows/build-radicale.yml`
- `.gitignore`

### 2. Enable GitHub Actions

Go to Settings → Actions → General and ensure actions are enabled.

### 3. Configure Packages

The workflow automatically publishes to GHCR using the `GITHUB_TOKEN`. No additional setup needed.

## Usage

### Pull the Image

```bash
# Latest version
docker pull ghcr.io/YOUR_USERNAME/YOUR_REPO:latest

# Specific version
docker pull ghcr.io/YOUR_USERNAME/YOUR_REPO:3.2.3
```

### Run Radicale

Basic run:
```bash
docker run -d \
  --name radicale \
  -p 5232:5232 \
  -v radicale-data:/var/lib/radicale/collections \
  ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
```

With custom config:
```bash
docker run -d \
  --name radicale \
  -p 5232:5232 \
  -v radicale-data:/var/lib/radicale/collections \
  -v ./my-config:/etc/radicale/config:ro \
  -v ./users:/etc/radicale/users:ro \
  ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  radicale:
    image: ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
    container_name: radicale
    ports:
      - "5232:5232"
    volumes:
      - radicale-data:/var/lib/radicale/collections
      - ./config:/etc/radicale/config:ro
      - ./users:/etc/radicale/users:ro
    restart: unless-stopped

volumes:
  radicale-data:
```

## Configuration

### Authentication

Edit the `config` file to enable authentication:

```ini
[auth]
type = htpasswd
htpasswd_filename = /etc/radicale/users
htpasswd_encryption = bcrypt
```

Create users file:
```bash
# Install htpasswd
apt-get install apache2-utils

# Create user
htpasswd -B -c users username
```

### SSL/TLS

For production, use a reverse proxy (nginx, Caddy) for SSL termination.

## Manual Trigger

Trigger a build manually:
1. Go to Actions tab
2. Select "Build Radicale Docker Image"
3. Click "Run workflow"

## Monitoring

The workflow runs hourly to check for new releases. View run history in the Actions tab.

## License

This build pipeline is provided as-is. Radicale is licensed under GPLv3, so we're mirroring that license.
