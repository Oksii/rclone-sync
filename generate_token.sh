#!/bin/bash

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo "rclone is not installed. Installing..."
    curl https://rclone.org/install.sh | sudo bash
fi

# Generate rclone config for OneDrive
echo "Generating rclone config for OneDrive..."
echo "Please provide your credentials:"

read -p "Enter Client ID: " CLIENT_ID
read -p "Enter Client Secret: " CLIENT_SECRET

# Create temporary rclone config
cat > rclone.conf << EOF
[onedrive]
type = onedrive
client_id = $CLIENT_ID
client_secret = $CLIENT_SECRET
EOF

# Get the authorization URL
AUTH_URL=$(rclone authorize "onedrive" --config rclone.conf --no-browser)

echo -e "\n================================================"
echo "Please visit this URL in any browser:"
echo -e "\n$AUTH_URL\n"
echo "================================================"
echo "After authorization, paste the authorization code here:"
read -p "Authorization Code: " AUTH_CODE

# Complete the authentication
echo $AUTH_CODE | rclone config update onedrive token - --config rclone.conf

# Base64 encode the token for Docker environment
TOKEN=$(base64 -w 0 rclone.conf)

echo -e "\n================================================"
echo "Your base64 encoded token for Docker environment:"
echo -e "\n$TOKEN\n"
echo "================================================"
echo "Add this to your Docker environment as TOKEN="
echo "Cleaning up temporary files..."

# Cleanup
rm rclone.conf

echo "Done! Use this token in your Docker environment variables."