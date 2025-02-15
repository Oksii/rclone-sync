# Rclone OneDrive Sync Docker Container

![Build Status](https://github.com/Oksii/rclone-sync/actions/workflows/docker-build.yml/badge.svg)
![Last Updated](https://img.shields.io/badge/last%20updated-2025--02--15-blue)

A Docker container that automatically syncs a local directory with OneDrive using rclone. Supports both scheduled sync intervals and immediate sync on file changes.

## Features

- 🔄 Bi-directional sync with OneDrive
- ⏰ Configurable sync intervals
- 👀 Watch mode for immediate sync on file changes
- 🏗️ Multi-architecture support (AMD64, ARM64, ARMv7)
- 🔐 Secure credential management
- 🐳 Easy Docker deployment

## Quick Start

```bash
docker run -d \
  -v /local/path/to/sync:/sync \
  -v /path/to/config:/config \
  -e PATH_TO_SYNC="Documents/Backup" \
  -e USER="your-email@example.com" \
  -e CLIENT_ID="your-client-id" \
  -e CLIENT_SECRET="your-client-secret" \
  -e SYNC_INTERVAL="1h" \
  ghcr.io/oksii/rclone-sync:latest
```

## Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PATH_TO_SYNC` | Path in OneDrive to sync | - | Yes |
| `USER` | OneDrive email address | - | Yes |
| `CLIENT_ID` | OneDrive OAuth client ID | - | Yes |
| `CLIENT_SECRET` | OneDrive OAuth client secret | - | Yes |
| `AUTH_TYPE` | Authentication type (pass/api) | `pass` | No |
| `SYNC_INTERVAL` | Sync interval or "watch" | `5m` | No |
| `DRIVE_TYPE` | OneDrive type (personal/business) | `personal` | No |
| `TOKEN` | Base64 encoded OAuth token | - | No |

## Sync Modes

### Interval Mode
Set `SYNC_INTERVAL` to a time duration:
- `5m` - Every 5 minutes
- `1h` - Every hour
- `2h30m` - Every 2 hours and 30 minutes

### Watch Mode
Set `SYNC_INTERVAL="watch"` for immediate sync on file changes.

## Volume Mounts

| Path | Description |
|------|-------------|
| `/sync` | Directory to sync with OneDrive |
| `/config` | rclone configuration directory |

## Authentication Setup

### Option 1: Client ID & Secret
1. Register your application in Azure AD
2. Get your Client ID and Client Secret
3. Provide them as environment variables

### Option 2: Manual Token Generation

1. On a machine with a browser, install rclone:
```bash
curl https://rclone.org/install.sh | sudo bash
```

2. Create a temporary rclone config:
```bash
rclone config
# Choose 'n' for new remote
# Name: onedrive
# Storage: Microsoft OneDrive
# Enter your client_id
# Enter your client_secret
# Choose 'n' for advanced config
```

3. Copy the generated config:
```bash
cat ~/.config/rclone/rclone.conf | base64 -w 0
```

4. Use this base64 encoded string as your TOKEN environment variable

### Option 3: SSH Tunnel Method

If you have SSH access to your headless server:

1. Create an SSH tunnel:
```bash
ssh -L 53682:localhost:53682 username@your-server
```

2. On the server, run:
```bash
rclone authorize "onedrive"
```

3. The browser will open locally through the SSH tunnel
4. Complete the authentication
5. The token will be saved on the server

## Docker Compose Example

```yaml
services:
  rclone-sync:
    image: ghcr.io/oksii/rclone-sync:latest
    volumes:
      - ./data:/sync
      - ./config:/config
    environment:
      - PATH_TO_SYNC=Documents/Backup
      - USER=your-email@example.com
      - CLIENT_ID=your-client-id
      - CLIENT_SECRET=your-client-secret
      - SYNC_INTERVAL=1h
    restart: unless-stopped
```

## Supported Architectures

- `linux/amd64` - 64-bit x86
- `linux/arm64` - 64-bit ARM (e.g., Raspberry Pi 4, Apple Silicon)
- `linux/arm/v7` - 32-bit ARM (e.g., Raspberry Pi 2/3)

## Building Locally

```bash
# Clone the repository
git clone https://github.com/Oksii/rclone-sync.git
cd rclone-sync

# Build the image
docker build -t rclone-sync .

# Build for specific platform
docker buildx build --platform linux/arm64 -t rclone-sync .
```