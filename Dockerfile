# Specify platform in base image for better compatibility
FROM --platform=$TARGETPLATFORM alpine:3.19

# Add platform-specific labels
ARG TARGETPLATFORM
ARG BUILDPLATFORM
LABEL org.opencontainers.image.created="2025-02-15T17:24:08Z"
LABEL org.opencontainers.image.authors="Oksii"
LABEL org.opencontainers.image.source="https://github.com/Oksii/rclone-sync"
LABEL org.opencontainers.image.description="OneDrive sync container using rclone with multi-arch support"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.base.name="alpine:3.19"
LABEL org.opencontainers.image.platform="${TARGETPLATFORM}"
LABEL org.opencontainers.image.build.platform="${BUILDPLATFORM}"

# Install required packages
RUN apk add --no-cache \
    rclone \
    ca-certificates \
    bash \
    inotify-tools

# Create necessary directories
RUN mkdir -p /sync /config

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Environment variables with defaults
ENV HOST=onedrive \
    PATH_TO_SYNC="" \
    USER="" \
    AUTH_TYPE="pass" \
    SYNC_INTERVAL="5m" \
    CLIENT_ID="" \
    CLIENT_SECRET="" \
    TOKEN="" \
    DRIVE_TYPE="personal"

# Volume for synced files
VOLUME /sync

ENTRYPOINT ["/entrypoint.sh"]