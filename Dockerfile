FROM alpine:3.19

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