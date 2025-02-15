# Rclone OneDrive Sync Docker Container

![Build Status](https://github.com/Oksii/rclone-sync/actions/workflows/docker-build.yml/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/ghcr.io/oksii/rclone-sync)
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

### Option 2: Token-based
1. Generate token using rclone:
```bash
rclone authorize "onedrive"
```
2. Base64 encode the token:
```bash
base64 -w 0 token.json > token.b64
```
3. Provide the encoded token as `TOKEN` environment variable

## Docker Compose Example

```yaml
version: '3.8'
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

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [rclone](https://rclone.org/) for the amazing sync tool
- [Docker](https://www.docker.com/) for containerization
- [GitHub Actions](https://github.com/features/actions) for CI/CD

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/Oksii/rclone-sync/issues/new).

---
Created by [Oksii](https://github.com/Oksii)  
Last Updated: 2025-02-15 17:25:17 UTC