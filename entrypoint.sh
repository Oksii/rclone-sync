#!/bin/bash
set -e

# Validate required environment variables
if [ -z "$PATH_TO_SYNC" ]; then
    echo "Error: PATH_TO_SYNC is required"
    exit 1
fi

if [ -z "$USER" ]; then
    echo "Error: USER is required"
    exit 1
fi

# Function to create base64 encoded token configuration
create_token_config() {
    if [ ! -z "$TOKEN" ]; then
        echo "$TOKEN" | base64 -d > /config/token.json
        echo "token = /config/token.json"
    fi
}

# Create rclone config with proper user credentials
echo "Creating rclone configuration for user: $USER"
cat > /config/rclone.conf << EOF
[$HOST]
type = onedrive
drive_type = $DRIVE_TYPE
$([ ! -z "$CLIENT_ID" ] && echo "client_id = $CLIENT_ID")
$([ ! -z "$CLIENT_SECRET" ] && echo "client_secret = $CLIENT_SECRET")
$(create_token_config)
EOF

# Function to perform sync
do_sync() {
    echo "Syncing /sync to $HOST:$PATH_TO_SYNC"
    rclone sync /sync "$HOST:$PATH_TO_SYNC" --config /config/rclone.conf --log-level INFO
}

# Function to watch for changes
watch_and_sync() {
    while inotifywait -r -e modify,create,delete,move /sync; do
        do_sync
    done
}

# Verify configuration
echo "Testing rclone configuration..."
if ! rclone lsd "$HOST:" --config /config/rclone.conf; then
    echo "Error: Unable to access $HOST with provided credentials"
    echo "Please check your authentication configuration"
    exit 1
fi

# Main execution
if [[ "$SYNC_INTERVAL" == "watch" ]]; then
    echo "Starting watch mode for changes..."
    watch_and_sync
else
    echo "Starting interval mode with sync every $SYNC_INTERVAL"
    while true; do
        do_sync
        sleep "$SYNC_INTERVAL"
    done
fi